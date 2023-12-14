//
//  BlogView.swift
//  RateMyDorm
//
//  Created by Manling Zhao on 12/9/23.
//

import SwiftUI
import SafariServices
import FirebaseFirestoreSwift
import FirebaseFirestore

struct BlogPost: Identifiable, Codable {
    @DocumentID var id: String?
    var title: String
    var description: String
    var link: String
    var coverPhoto: String
    var universityName: String
}

struct BlogView: View {
    @State private var selectedBlogURL: URL?
    @State private var isSafariViewPresented = false
    @State private var posts = [BlogPost]()
    @Binding var universityName: String

    var body: some View {
        NavigationStack {
            ScrollView{
                VStack {
                    ForEach(posts) { post in
                        BlogCardView(title: .constant(post.title),
                                     description: .constant(post.description),
                                     photo: .constant(post.coverPhoto))
                        .padding(.vertical, 5)
                        .onTapGesture {
                            selectedBlogURL = URL(string: post.link)
                            isSafariViewPresented = true
                        }
                    }
                }
            }
            .navigationTitle("Resources")   // decide to change from blog to resources
            .fullScreenCover(isPresented: $isSafariViewPresented) {
                SafariView(url: (selectedBlogURL ?? URL(string: "https://www.google.com"))!)
                    .ignoresSafeArea()
            }
        }
        .onAppear {
            fetchData()
        }
    }
    
    func fetchData() {
        let db = Firestore.firestore()
        db.collection("blog")
            .whereField("universityName", isEqualTo: universityName)
            .addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(error!)")
                    return
                }
                self.posts = documents.compactMap { queryDocumentSnapshot -> BlogPost? in
                    return try? queryDocumentSnapshot.data(as: BlogPost.self)
                }
            }
    }
}

struct SafariView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> UIViewController {
        return SFSafariViewController(url: url)
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
}

struct BlogView_Previews: PreviewProvider {
    static var previews: some View {
        BlogView(universityName: .constant("Boston University"))
    }
}
