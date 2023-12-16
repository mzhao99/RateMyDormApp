//
//  PostView.swift
//  RateMyDorm
//
//  Created by 田诗韵 on 12/15/23.
//

import SwiftUI
import FirebaseFirestore

struct Forum: Identifiable, Codable {
    @DocumentID var id: String?
    var parentId: String?
    var title: String
    var description: String
    var timeStamp: Date
    var username: String
    // other attributes...
}

class PostViewModel: ObservableObject {
    @Published var forums: [Forum] = []
    @EnvironmentObject var userViewModel: UserViewModel

    private var db = Firestore.firestore()

    func fetchForums() {
        guard let forumIds = userViewModel.currentUser?.forumIds else { return }

        forums = []
        for id in forumIds {
            db.collection("forum").document(id).getDocument { [weak self] (document, error) in
                if let document = document, document.exists {
                    if let forum = try? document.data(as: Forum.self) {
                        DispatchQueue.main.async {
                            self?.forums.append(forum)
                        }
                    }
                } else {
                    print("Document does not exist")
                }
            }
        }
    }
    
    func fetchComments(for parentId: String, completion: @escaping ([Forum]) -> Void) {
            db.collection("forum").whereField("parentId", isEqualTo: parentId).getDocuments { (querySnapshot, err) in
                var comments: [Forum] = []
                if let err = err {
                    print("Error getting comments: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        if let forum = try? document.data(as: Forum.self) {
                            comments.append(forum)
                        }
                    }
                }
                DispatchQueue.main.async {
                    completion(comments)
                }
            }
        }
    // Additional methods...
}

struct PostView: View {
    @ObservedObject var viewModel: PostViewModel

    var body: some View {
        List {
            ForEach(viewModel.forums.filter { $0.parentId == "none" }) { forum in
                NavigationLink(destination: DetailView(selectedForum: forum, viewModel: viewModel)) {
                    VStack(alignment: .leading) {
                        Text(forum.title).font(.headline)
                        Text(forum.description).font(.subheadline)
                        Text("Posted by \(forum.username) on \(forum.timeStamp, formatter: DateFormatter.shortDate)")
                    }
                }
            }
        }
        .onAppear(perform: viewModel.fetchForums)
        .navigationBarTitle("Posts")
    }
}

extension DateFormatter {
    static let shortDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
}

struct DetailView: View {
    var selectedForum: Forum
    @ObservedObject var viewModel: PostViewModel
    @State private var comments: [Forum] = []

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text(selectedForum.title).font(.headline)
                Text(selectedForum.description).font(.subheadline)
                Text("Posted by \(selectedForum.username) on \(selectedForum.timeStamp.formatted())")
                Divider()
                Text("Comments").font(.title2)

                ForEach(comments) { comment in
                                    VStack(alignment: .leading) {
                                        Text(comment.description).font(.subheadline)
                                        Text("Comment by \(comment.username) on \(comment.timeStamp, formatter: DateFormatter.shortDate)")
                                    }
                                }
            }
        }
        .navigationBarTitle("Detail", displayMode: .inline)
    }
}




extension Forum {
    static var mockData: [Forum] {
        [
            Forum(id: "1", parentId: "none", title: "Welcome to SwiftUI", description: "This is a post about SwiftUI", timeStamp: Date(), username: "UserA"),
            Forum(id: "2", parentId: "1", title: "", description: "This is a comment", timeStamp: Date(), username: "UserB"),
            Forum(id: "3", parentId: "1", title: "", description: "This is a comment", timeStamp: Date(), username: "UserC"),
            // Add more mock forums as needed
        ]
    }
}


class MockUserViewModel: UserViewModel {
    override init() {
        super.init()
        self.currentUser = UserModel(id: "1", username: "a", email: "a@gmail.com", forumIds: ["1", "2"], reviewIds: ["1"], universityName: "northeastern")
    }
}

class MockPostViewModel: PostViewModel {
    override init() {
        super.init()
        self.forums = Forum.mockData
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        let mockUserViewModel = MockUserViewModel()
        let mockPostViewModel = MockPostViewModel()
        mockPostViewModel.forums = Forum.mockData

        return PostView(viewModel: mockPostViewModel)
            .environmentObject(mockUserViewModel)
    }
}



//struct PostView_Previews: PreviewProvider {
//    static var previews: some View {
//        let mockUserViewModel = MockUserViewModel()
//        let mockPostViewModel = MockForumViewModel2() // Assuming you have a MockPostViewModel
//
//        PostView(viewModel: mockPostViewModel)
//            .environmentObject(mockUserViewModel)
//    }
//}
//
//class MockUserViewModel: UserViewModel {
//    override init() {
//        super.init()
//        // Set up mock user data
//        self.currentUser = UserModel(id: "1", username: "a", email: "a@gmail.com", forumIds: ["1","2"], reviewIds: ["1"], universityName: "northeastern")
//    }
//    
//    
//    class MockForumViewModel2: PostViewModel {
//        override init() {
//            super.init()
//            self.forums = Forum.mockData
//        }
//        
//    }
//    
//    
//    
//
