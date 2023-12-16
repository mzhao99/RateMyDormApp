//
//  CommentView.swift
//  RateMyDorm
//
//  Created by 田诗韵 on 12/15/23.
//

import SwiftUI

import FirebaseFirestore

class CommentViewModel: ObservableObject {
    @Published var forums: [Forum] = []
    @Published var userComments: [Forum] = []
    private var db = Firestore.firestore()
    @EnvironmentObject var userViewModel: UserViewModel

    // Fetch all forums
    func fetchForums() {
        db.collection("forum").getDocuments { (querySnapshot, err) in
            // handle fetching all forums
            if let documents = querySnapshot?.documents {
                self.forums = documents.compactMap { try? $0.data(as: Forum.self) }
            }
        }
    }

    // Fetch comments by current user
    func fetchUserComments() {
        guard let userId = userViewModel.currentUser?.id else { return }

        db.collection("forum")
          .whereField("userId", isEqualTo: userId)
          .whereField("parentId", isNotEqualTo: "none")
          .getDocuments { (querySnapshot, err) in
              if let documents = querySnapshot?.documents {
                  self.userComments = documents.compactMap { try? $0.data(as: Forum.self) }
              }
          }
    }
    func deleteComment(comment: Forum, completion: @escaping (Bool) -> Void) {
            guard let commentId = comment.id, let userId = userViewModel.currentUser?.id else {
                completion(false)
                return
            }

            let userDocument = db.collection("users").document(userId)
            let commentDocument = db.collection("forums").document(commentId)

            // Begin a batch write to ensure atomicity
            let batch = db.batch()

            // Delete the comment document
            batch.deleteDocument(commentDocument)

            // Update the user document to remove the commentId from forumIds
            batch.updateData(["forumIds": FieldValue.arrayRemove([commentId])], forDocument: userDocument)

            // Commit the batch write
            batch.commit { err in
                if let err = err {
                    print("Error writing batch \(err)")
                    completion(false)
                } else {
                    print("Comment successfully deleted.")
                    self.fetchUserComments() // Refresh the comments list after deletion
                    completion(true)
                }
            }
        }
}


struct CommentView: View {
    @ObservedObject var viewModel: CommentViewModel

    var body: some View {
        List {
            ForEach(viewModel.userComments) { comment in
                VStack(alignment: .leading) {
                    if let parentForum = viewModel.forums.first(where: { $0.id == comment.parentId }) {
                        Text(parentForum.title).font(.headline)
                        Text("Posted by \(parentForum.username)").font(.subheadline)
                        Text(parentForum.description)
                    }
                    Divider()
                    Text(comment.description)

                    Button("Delete Comment") {
                        viewModel.deleteComment(comment: comment) { success in
                            if success {
                                print("Comment deleted successfully.")
                            } else {
                                print("Failed to delete comment.")
                            }
                        }
                    }
                    .foregroundColor(.red)
                }
            }
        }
        .onAppear {
            viewModel.fetchUserComments()
            viewModel.fetchForums()
        }
    }
}


//#Preview {
//    CommentView()
//}
