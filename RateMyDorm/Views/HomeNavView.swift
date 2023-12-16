//
//  HomeNavView.swift
//  RateMyDorm
//
//  Created by Manling Zhao on 12/9/23.
//

import SwiftUI

// a customized tab bar to allow modal subviews
struct HomeNavView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var selectedIndex = 0
    @State private var showAddRating = false
    
    @State private var universityName = "Northeastern University" // change to binding var later
    
    let icons = ["house", "book", "plus", "quote.bubble", "person"]
    let captions = ["Home", "Resources", "Add Review", "Forum", "Me"]
    
    var body: some View {
        VStack {
            // Content
            ZStack {
                AddRatingView(showAddRating: $showAddRating)
                
                switch selectedIndex {
                case 0:
                    HomeView()
                case 1:
                    BlogView(universityName: $universityName)
                case 3:
                    ForumView()
                case 4:
                    UserProfileView()
                default:
                    HomeView()
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
    }
}



struct HomeNavView_Previews: PreviewProvider {
    static var previews: some View {
        // Create a mock user model
        let mockUser = UserModel(id: "1", username: "TestUser", email: "test@example.com")

        // Create a mock UserViewModel
        let userViewModel = UserViewModel()
        userViewModel.currentUser = mockUser

        // Create a mock PersistenceController for Core Data
        let persistenceController = PersistenceController.preview

        return HomeNavView()
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
            .environmentObject(userViewModel)
    }
}


