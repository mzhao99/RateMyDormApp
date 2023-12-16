//
//  ProfileView.swift
//  RateMyDorm
//
//  Created by 田诗韵 on 12/13/23.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift
import FirebaseFirestore

struct ProfileView: View {
    @State private var selectedTab = "Rating"
    @State private var userSignOut = false
    @EnvironmentObject var userViewModel: UserViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                // User Profile Header
                HStack {
                    VStack(alignment: .leading) {
                        Text("Welcome back,")
                            .font(.headline)
                            .foregroundColor(.gray)
                        Text(userViewModel.currentUser?.username ?? "Buddy")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                    }
                    Spacer()
                    Button("Logout") {
                        do {
                            try Auth.auth().signOut()
                            userSignOut = true
                        } catch let signOutError as NSError {
                            print("Error signing out: %@", signOutError)
                        }
                    }
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
                    ReviewsListView().tag("Rating")
                    PostView().tag("Post")
                    CommentView().tag("Comment")
                }
                
                
                
                NavigationLink(
                    destination: LoginView().navigationBarHidden(true),
                    isActive: $userSignOut,
                    label: { EmptyView() }
                )
                .hidden()
                
                Spacer()
            }
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
            .environmentObject(UserViewModel())  // Add this line
    }
}
