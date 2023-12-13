//
//  BlogView.swift
//  RateMyDorm
//
//  Created by Manling Zhao on 12/9/23.
//

import SwiftUI
import SafariServices

struct BlogView: View {
    @State private var selectedBlogURL: URL?
    @State private var isSafariViewPresented = false
    
    private let blogData: [[String: Any]] = [
        [
            "title": "First Blog",
            "author": "John Doe",
            "description": "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
        ],
        [
            "title": "Second Blog",
            "author": "Jane Doe",
            "description": "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
        ],
        [
            "title": "Third Blog",
            "author": "John Doe",
            "description": "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
        ],
        [
            "title": "Fourth Blog",
            "author": "John Doe",
            "description": "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
        ]
    ]
    
    private let urls: [URL] = [URL(string: "https://www.example.com/blog1")!, URL(string: "https://www.example.com/blog1")!, URL(string: "https://www.example.com/blog1")!, URL(string: "https://www.example.com/blog1")!]
    
    var body: some View {
        NavigationStack {
            ScrollView{
                VStack {
                    ForEach(0..<blogData.count, id: \.self) { num in
                        BlogCardView(title: .constant(blogData[num]["title"] as! String),
                                     author: .constant(blogData[num]["author"] as! String),
                                     description: .constant(blogData[num]["description"] as! String),
                                     photo: .constant(nil))
                        .padding(.vertical, 5)
                        .onTapGesture {
                            selectedBlogURL = urls[num]
                            isSafariViewPresented = true
                            
                        }
                    }
                }
            }
            .navigationTitle("Blogs")
            .fullScreenCover(isPresented: $isSafariViewPresented) {
                SafariView(url: URL(string: "https://google.com")!)
                    .ignoresSafeArea()
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
        BlogView()
    }
}
