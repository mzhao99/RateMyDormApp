//
//  CommentView.swift
//  RateMyDorm
//
//  Created by 田诗韵 on 12/15/23.
//

import SwiftUI

import FirebaseFirestore

import SwiftUI
import FirebaseFirestore

struct CommentView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var comments: [ForumModel] = []

    init(comments: [ForumModel] = []) {
            _comments = State(initialValue: comments)
        }
    
    var body: some View {
        List(comments) { comment in
            VStack(alignment: .leading) {
                Text("Post: \(comment.title ?? "Unknown")").font(.headline)// Placeholder for post title
                // Fetch and display the post details associated with the comment
                // This is simplified for demonstration purposes
                HStack {
                    Text(comment.username).font(.caption)
                    Spacer()
                    Text("\(comment.timeStamp.formatted())").font(.caption)
                }
                Divider()
                Text(comment.description).font(.body)
            }
        }
        .onAppear {
            loadUserComments()
        }
    }

    private func loadUserComments() {
        guard let forumIds = userViewModel.currentUser?.forumIds else { return }

        let db = Firestore.firestore()
        for forumId in forumIds {
            db.collection("forum").document(forumId).getDocument { document, error in
                guard let document = document, document.exists else {
                    print("Error fetching document: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                do {
                    let comment = try document.data(as: ForumModel.self)
                    if comment.parentId != "none" {
                        DispatchQueue.main.async {
                            self.comments.append(comment)
                        }
                    }
                } catch {
                    print("Error decoding comment: \(error)")
                }
            }
        }
    }
}

struct CommentView_Previews: PreviewProvider {
    static var previews: some View {
        CommentView(comments: SampleData.comments)
            .environmentObject(MockUserViewModel())
    }
}

