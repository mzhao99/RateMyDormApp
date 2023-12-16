//
//  ForumHomeView.swift
//  RateMyDorm
//
//  Created by 田诗韵 on 12/15/23.
//
import Foundation
import FirebaseFirestore
import SwiftUI

struct ForumPost: Identifiable, Codable {
    var id: String
    var title: String
    var description: String
    var timeStamp: Date
    var userId: String
    var username: String
    var parentId: String?
    
    init(id: String, title: String, description: String, timeStamp: Date, userId: String, username: String, parentId: String?) {
           self.id = id
           self.title = title
           self.description = description
           self.timeStamp = timeStamp
           self.userId = userId
           self.username = username
           self.parentId = parentId
       }


    // Custom init from Firestore document
    init?(document: [String: Any]) {
        guard let id = document["id"] as? String,
              let title = document["title"] as? String,
              let description = document["description"] as? String,
              let timeStamp = (document["timeStamp"] as? Timestamp)?.dateValue(),
              let userId = document["userId"] as? String,
              let username = document["username"] as? String else {
            return nil
        }
        self.id = id
        self.title = title
        self.description = description
        self.timeStamp = timeStamp
        self.userId = userId
        self.username = username
        self.parentId = document["parentId"] as? String
    }
}



class ForumViewModel: ObservableObject {
    @Published var forumPosts: [ForumPost] = []

    init() {
        fetchForumPosts()
    }

    func fetchForumPosts() {
        let db = Firestore.firestore()
        db.collection("forum").whereField("parentId", isEqualTo: "none")
           .order(by: "timeStamp", descending: true)
           .getDocuments { snapshot, error in
               if let error = error {
                   print("Error getting documents: \(error)")
               } else {
                   self.forumPosts = snapshot?.documents.compactMap { docSnapshot -> ForumPost? in
                       ForumPost(document: docSnapshot.data())
                   } ?? []
               }
           }
    }
}




struct ForumListView: View {
    @ObservedObject var viewModel = ForumViewModel()
    @EnvironmentObject var userViewModel: UserViewModel

    var body: some View {
        NavigationView {
            List(viewModel.forumPosts) { post in
                NavigationLink(destination: ForumDetailView(forumPost: post, viewModel: viewModel)) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(post.title).font(.headline)
                        Text(post.description).lineLimit(2).font(.subheadline)
                        Text("Posted by \(post.username) on \(post.timeStamp.formatted())").font(.caption)
                    }
                }
            }
            .navigationBarItems(leading:
                            Text("Forums")
                                .font(.largeTitle)
                                .foregroundColor(Color.teal)
                                .padding(.vertical, 10),
                            trailing:
                            NavigationLink(destination: AddPostView()) {
                                Text("Add Post")
                            }
                        )
        }
    }
}


struct AddPostView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var title: String = ""
    @State private var description: String = ""

    var body: some View {
        Form {
            TextField("Title", text: $title)
            TextField("Description", text: $description)
            Button("Save Post") {
                savePost()
                presentationMode.wrappedValue.dismiss()
            }
        }
    }

    private func savePost() {
        guard let userId = userViewModel.currentUser?.id else { return }

        let db = Firestore.firestore()
        let newPostId = UUID().uuidString

        let newPostData: [String: Any] = [
            "id": newPostId,
            "title": title,
            "description": description,
            "timeStamp": Timestamp(date: Date()),
            "userId": userId,
            "username": userViewModel.currentUser?.username ?? "",
            "parentId": "none"
        ]

        db.collection("forum").document(newPostId).setData(newPostData) { error in
            if let error = error {
                // Handle the error
                print("Error saving new post: \(error)")
                return
            }

            // If successful, update the user's forumIds
            updateUserForumIds(with: newPostId)
        }
    }
    
    private func updateUserForumIds(with newPostId: String) {
        guard let userId = userViewModel.currentUser?.id else { return }

        let db = Firestore.firestore()
        let userRef = db.collection("user").document(userId)

        // Assuming `forumIds` is an array field in the user's document
        userRef.updateData([
            "forumIds": FieldValue.arrayUnion([newPostId])
        ]) { error in
            if let error = error {
                // Handle the error
                print("Error updating user's forumIds: \(error)")
            } else {
                // Successfully updated user's forumIds
                print("User's forumIds updated with new post ID")
            }
        }
    }


}



struct ForumDetailView: View {
    var forumPost: ForumPost
    @ObservedObject var viewModel: ForumViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text(forumPost.title).font(.headline)
                Text(forumPost.description).font(.body)
                Text("Posted by \(forumPost.username) on \(forumPost.timeStamp.formatted())").font(.caption)
                Divider()
                Text("Comments:").font(.headline)
                ForEach(viewModel.forumPosts.filter { $0.parentId == forumPost.id }) { comment in
                    VStack(alignment: .leading) {
                        Text(comment.description)
                        Text("Comment by \(comment.username)").font(.caption)
                    }
                    .padding(.bottom, 5)
                }
            }
            .padding()
        }
        .navigationBarTitle(Text(forumPost.title), displayMode: .inline)
    }
}

class MockForumViewModel: ForumViewModel {
//    @Published var forumPosts: [ForumPost] = []
    override init() {
            super.init()
            let mockDocument1: [String: Any] = [
                "id": "1",
                "title": "First Post",
                "description": "This is the first forum post.",
                "timeStamp": Timestamp(date: Date()),
                "userId": "user1",
                "username": "User One",
                "parentId": "none"
            ]
            
            if let post = ForumPost(document: mockDocument1) {
                forumPosts.append(post)
            }
        }
    

    
}


struct ForumListView_Previews: PreviewProvider {
    static var previews: some View {
        ForumListView(viewModel: MockForumViewModel())
    }
}


