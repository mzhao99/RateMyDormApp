//
//  ProfileView.swift
//  RateMyDorm
//
//  Created by 田诗韵 on 12/13/23.
//

import SwiftUI

import SwiftUI

struct ProfileView: View {
    @State private var selectedTab = "Rating"
    @ObservedObject var postViewModel = PostViewModel()
    @ObservedObject var commentViewModel = CommentViewModel()
    
    var body: some View {
        VStack {
            // User Profile Header
            HStack {
                VStack(alignment: .leading) {
                    Text("Welcome back,")
                        .font(.headline)
                        .foregroundColor(.gray)
                    Text("Shiyun")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }
                Spacer()
            }
            .padding()
            
            // Tabs for Rating, Post, Comment
            HStack {
                TabButton(title: "Rating", selectedTab: $selectedTab)
                TabButton(title: "Post", selectedTab: $selectedTab)
                TabButton(title: "Comment", selectedTab: $selectedTab)
            }
            .padding(.horizontal)
            
            // Content below tabs
            TabView(selection: $selectedTab) {
                ReviewListView().tag("Rating")
                PostView(viewModel: postViewModel).tag("Post")
                CommentView(viewModel: commentViewModel).tag("Comment")
            }
            
            Spacer()
        }
    }
}

struct TabButton: View {
    let title: String
    @Binding var selectedTab: String
    
    var body: some View {
        Button(action: {
            selectedTab = title
        }) {
            Text(title)
                .foregroundColor(selectedTab == title ? .black : .gray)
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                .background(selectedTab == title ? Color.blue.opacity(0.2) : Color.clear)
                .cornerRadius(10)
        }
    }
}







struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}

