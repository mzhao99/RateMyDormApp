//
//  HomeNavView.swift
//  RateMyDorm
//
//  Created by Manling Zhao on 12/9/23.
//

import SwiftUI

// a customized tab bar to allow modal subviews
struct HomeNavView: View {
    @State private var selectedIndex = 0
    @State private var showAddRating = false
    
    @State private var universityName = "Northeastern University" // change to binding var later
    
    @EnvironmentObject var userViewModel: UserViewModel
    
    let icons = ["house", "book", "plus", "quote.bubble", "person"]
    let captions = ["Home", "Resource", "Add Review", "Forum", "Me"]
    
    var body: some View {
        VStack {
            // Content
            ZStack {
                AddRatingView(showAddRating: $showAddRating, universityName: $universityName)
                
                switch selectedIndex {
                case 0:
                    HomeView(universityName: $universityName)
                case 1:
                    BlogView(universityName: $universityName)
                case 3:
                    ForumListView()
                case 4:
                    ProfileView()
                default:
                    HomeView(universityName: $universityName)
                }
            }
            
            Divider()
            HStack {
                ForEach(0..<5, id: \.self) { number in
                    Spacer()
                    Button(action: {
                        // modally present the new view if 'add review' is clicked
                        if number == 2 {
                            showAddRating.toggle()
                        } else {
                            self.selectedIndex = number
                        }
                    }, label: {
                        // customize the 'add review' button
                        if number == 2 {
                            Image(systemName: icons[number])
                                .font(.system(size: 25))
                                .foregroundColor(.white)
                                .frame(width: 60, height: 60)
                                .background(.teal)
                                .cornerRadius(30)
                            
                        } else {
                            VStack(spacing: 2) {
                                Image(systemName: icons[number])
                                    .font(.system(size: 25))
                                    .foregroundColor(selectedIndex == number ? .teal : Color(UIColor.lightGray))
                                Text(captions[number])
                                    .foregroundColor(selectedIndex == number ? .teal : Color(UIColor.lightGray))
                                    .font(.caption)
                            }
                        }
                    })
                    Spacer()
                }
            }
        }
//        .onAppear {
//            print(userViewModel.currentUser?.email ?? "N/A")
//        }
    }
}

struct HomeNavView_Previews: PreviewProvider {
    static var previews: some View {
        let userViewModel = UserViewModel()
        HomeNavView().environmentObject(userViewModel)
    }
}
