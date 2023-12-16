//
//  PostView.swift
//  RateMyDorm
//
//  Created by 田诗韵 on 12/15/23.
//

import SwiftUI
import FirebaseFirestore

import SwiftUI
import FirebaseFirestore

struct ForumModel: Identifiable, Codable, Equatable {
    var id: String
    var title: String
    var description: String
    var username: String
    var timeStamp: Date
    var parentId: String?
}

struct PostView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var posts: [ForumModel] = []
    
    init(posts: [ForumModel] = []) {
            _posts = State(initialValue: posts)
        }


    var body: some View {
        List(posts) { post in
            VStack(alignment: .leading) {
                Text(post.title).font(.headline)
                Text(post.description).font(.subheadline)
                HStack {
                    Text(post.username).font(.caption)
                    Spacer()
                    Text("\(post.timeStamp.formatted())").font(.caption)
                }
            }
        }
        .onAppear {
            loadUserPosts()
        }
    }

    private func loadUserPosts() {
        guard let forumIds = userViewModel.currentUser?.forumIds else { return }

        let db = Firestore.firestore()
        for forumId in forumIds {
            db.collection("forum").document(forumId).getDocument { document, error in
                guard let document = document, document.exists else {
                    print("Error fetching document: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                do {
                    let post = try document.data(as: ForumModel.self)
                    if post.parentId == "none" {
                        DispatchQueue.main.async {
                            self.posts.append(post)
                        }
                    }
                } catch {
                    print("Error decoding post: \(error)")
                }
            }
        }
    }
}


// Mock Data
struct SampleData {
    static let posts: [ForumModel] = [
        ForumModel(id: "1", title: "Post Title 1", description: "Description 1", username: "User1", timeStamp: Date(), parentId: "none"),
        ForumModel(id: "2", title: "Post Title 2", description: "Description 2", username: "User2", timeStamp: Date(), parentId: "none")
    ]

    static let comments: [ForumModel] = [
        ForumModel(id: "3", title: "Comment Title 1", description: "Comment 1", username: "User1", timeStamp: Date(), parentId: "1"),
        ForumModel(id: "4", title: "Comment Title 2", description: "Comment 2", username: "User2", timeStamp: Date(), parentId: "2")
    ]
}

// Mock UserViewModel
class MockUserViewModel: UserViewModel {
    override init() {
        super.init()
        self.currentUser = UserModel(id: "mockID", username: "mockUser", email: "mock@example.com", forumIds: ["1", "2"], reviewIds: ["1", "2"], universityName: "Mock University")
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView(posts: SampleData.posts)
            .environmentObject(MockUserViewModel())
    }
}
