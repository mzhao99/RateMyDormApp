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
    
    var body: some View {
        VStack {
            // User Profile Header
            HStack {
                VStack(alignment: .leading) {
                    Text("Welcome back,")
                        .font(.headline)
                        .foregroundColor(.gray)
                    Text("Username")
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
                RatingView().tag("Rating")
                PostView().tag("Post")
                CommentView().tag("Comment")
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


//views for Rating, Post, and Comment
//we need to change it later, it is just test
struct RatingView: View {
    var body: some View {
        Text("Rating Content")
    }
}

struct PostView: View {
    var body: some View {
        Text("Post Content")
    }
}

struct CommentView: View {
    var body: some View {
        Text("Comment Content")
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView()
    }
}

