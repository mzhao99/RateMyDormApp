//
//  BlogView.swift
//  RateMyDorm
//
//  Created by Manling Zhao on 12/9/23.
//

import SwiftUI

struct BlogView: View {
    private let blogData: [[String: Any]] = [
        [
            "title": "First Blog",
            "author": "John Doe",
            "description": "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
//            "photo": nil
        ],
        [
            "title": "Second Blog",
            "author": "Jane Doe",
            "description": "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
//            "photo": nil
        ],
        [
            "title": "Third Blog",
            "author": "John Doe",
            "description": "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
//            "photo": nil
        ],
        [
            "title": "Fourth Blog",
            "author": "John Doe",
            "description": "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
//            "photo": nil
        ]
    ]
    
    
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
                    }
                }
            }
            .navigationTitle("Blogs")
        }
    }
}


struct BlogView_Previews: PreviewProvider {
    static var previews: some View {
        BlogView()
    }
}
