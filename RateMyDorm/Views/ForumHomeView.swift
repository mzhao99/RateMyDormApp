//
//  ForumHomeView.swift
//  RateMyDorm
//
//  Created by 田诗韵 on 12/15/23.
//
import Foundation
import FirebaseFirestore
import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct ForumPost: Identifiable, Codable {
    var id: String?
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
    @Published var comments: [ForumPost] = []

    init() {
        fetchForumPosts()
    }

    func fetchForumPosts() {
        let db = Firestore.firestore()
        db.collection("forum")
          .whereField("parentId", isEqualTo: "none")
//          .order(by: "timeStamp", descending: true)
          .getDocuments { [weak self] (snapshot, error) in
              if let error = error {
                  print("Error getting documents: \(error)")
              } else {
                  self?.forumPosts = snapshot?.documents.compactMap { document in
                      try? document.data(as: ForumPost.self)
                  } ?? []
              }
          }
    }
    
    
    func fetchComments(for postId: String) {
            let db = Firestore.firestore()
            db.collection("forum")
              .whereField("parentId", isEqualTo: postId)
              .getDocuments { [weak self] (snapshot, error) in
                  if let error = error {
                      print("Error getting documents: \(error)")
                  } else {
                      self?.comments = snapshot?.documents.compactMap { document in
                          try? document.data(as: ForumPost.self)
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
            .onAppear {
                            viewModel.fetchForumPosts()
                        }
            
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

extension ForumDetailView {
    private func addComment() {
        guard let userId = userViewModel.currentUser?.id,
              let username = userViewModel.currentUser?.username else { return }

        let db = Firestore.firestore()
        let newCommentId = UUID().uuidString

        let newCommentData: [String: Any] = [
            "id": newCommentId,
            "title": forumPost.title, // Assuming comments use the same title as the post
            "description": newCommentText,
            "timeStamp": Timestamp(date: Date()),
            "userId": userId,
            "username": username,
            "parentId": forumPost.id
        ]

        db.collection("forum").document(newCommentId).setData(newCommentData) { error in
            if let error = error {
                print("Error saving new comment: \(error)")
                return
            }
            updateUserForumIds(with: newCommentId)
                
                    if let postId = forumPost.id {
                        viewModel.fetchComments(for: postId)
                    }
                
        }
    }

    private func updateUserForumIds(with newCommentId: String) {
        guard let userId = userViewModel.currentUser?.id else { return }

        let db = Firestore.firestore()
        let userRef = db.collection("user").document(userId)

        userRef.updateData([
            "forumIds": FieldValue.arrayUnion([newCommentId])
        ]) { error in
            if let error = error {
                print("Error updating user's forumIds: \(error)")
            } else {
                print("User's forumIds updated with new comment ID")
            }
        }
    }
}


struct ForumDetailView: View {
    var forumPost: ForumPost
    @ObservedObject var viewModel: ForumViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var newCommentText: String = ""

    var body: some View {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    // Post details
                    Text(forumPost.title).font(.headline)
                    Text(forumPost.description).font(.body)
                    Text("Posted by \(forumPost.username) on \(forumPost.timeStamp.formatted())").font(.caption)
                    Divider()

                    // Existing comments
                    Text("Comments:").font(.headline)
                    ForEach(viewModel.comments) { comment in
                        VStack(alignment: .leading) {
                            Text(comment.description)
                            Text("Comment by \(comment.username)").font(.caption)
                        }
                        .padding(.bottom, 5)
                    }

                    // Add comment section
                    Divider()
                    Text("Add a Comment").font(.headline)
                    TextField("Type your comment here...", text: $newCommentText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    Button("Post Comment") {
                        addComment()
                    }
                    .padding(.bottom)
                }
                .padding()
            }
            .onAppear {
                if let postId = forumPost.id {
                    viewModel.fetchComments(for: postId)
                }
            }
            .navigationBarTitle(Text(forumPost.title), displayMode: .inline)
        }
}

//class MockForumViewModel: ForumViewModel {
////    @Published var forumPosts: [ForumPost] = []
//    override init() {
//            super.init()
//            let mockDocument1: [String: Any] = [
//                "id": "1",
//                "title": "First Post",
//                "description": "This is the first forum post.",
//                "timeStamp": Timestamp(date: Date()),
//                "userId": "user1",
//                "username": "User One",
//                "parentId": "none"
//            ]
//            
//            if let post = ForumPost(document: mockDocument1) {
//                forumPosts.append(post)
//            }
//        }
//    
//
//    
//}


//struct ForumListView_Previews: PreviewProvider {
//    static var previews: some View {
//        ForumListView(viewModel: MockForumViewModel())
//    }
//}


