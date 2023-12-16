//
//  LoginView.swift
//  RateMyDorm
//
//  Created by 田诗韵 on 12/12/23.
//

import SwiftUI
import FBSDKLoginKit
import Firebase
import FirebaseFirestoreSwift
import FirebaseFirestore

struct FacebookLoginButton: UIViewRepresentable {
    func makeUIView(context: Context) -> FBLoginButton {
        let loginButton = FBLoginButton()
        loginButton.permissions = ["public_profile", "email"]
        return loginButton
    }
    
    func updateUIView(_ uiView: FBLoginButton, context: Context) {}
}

class UserViewModel: ObservableObject {
    @Published var currentUser: UserModel?
    @Published var reviews: [ReviewModel] = []

        private var db = Firestore.firestore()

        // Add this method to your existing UserViewModel
    func fetchUserReviews() {
        guard let reviewIds = currentUser?.reviewIds, !reviewIds.isEmpty else {
            // Handle empty reviewIds
            return
        }
        
        // Existing logic to clear previous reviews
        self.reviews = []
        
        for reviewId in reviewIds {
            db.collection("review").document(reviewId).getDocument { (document, error) in
                if let document = document, document.exists {
                    do {
                        let review = try document.data(as: ReviewModel.self)
                        DispatchQueue.main.async {
                            self.reviews.append(review)
                        }
                    } catch {
                        print("Error decoding review: \(error)")
                    }
                } else {
                    print("Document does not exist")
                }
            }
        }
    }
}

struct UserModel: Identifiable, Codable, Equatable {
    @DocumentID var id: String?
    var username: String
    var email: String
    var forumIds: [String]
    var reviewIds: [String]
    var universityName: String
}

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var username = ""
    @State private var showErrorMessage = false
    @State private var errorMessage = ""
    @State private var loginSuccessful = false
    @EnvironmentObject var userViewModel: UserViewModel
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 15) {
                Text("RateMyDorm")
                    .font(.largeTitle)
                    .foregroundColor(Color.teal)
                    .padding(.vertical, 10)
                
                TextField("Email", text: $email)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(UIColor.lightGray), lineWidth: 1.5)
                    )
                    .autocapitalization(.none)
                
                SecureField("Password", text: $password)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(UIColor.lightGray), lineWidth: 1.5)
                    )
                    .autocapitalization(.none)
                
                if (showErrorMessage) {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }
                
                Button(action: {
                    login()
                }) {
                    Text("Log In")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .frame(height: 50)
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .bold))
                        .background(Color.teal)
                        .cornerRadius(20)
                }
                .padding(.top, 10)

                NavigationLink(destination: CreateUserView()) {
                    Text("Create an account")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .frame(height: 50)
                        .foregroundColor(Color.teal)
                        .font(.system(size: 20, weight: .bold))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.teal, lineWidth: 2)
                        )
                }
                
                FacebookLoginButton()
                    .frame(width: 200, height: 28)
                    .padding()
                
                NavigationLink(
                    destination: HomeNavView().navigationBarHidden(true),
                    isActive: $loginSuccessful,
                    label: { EmptyView() }
                )
                .hidden()
                
                Spacer()
            }
            .padding()
        }
    }
    
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if error != nil {
                if error!.localizedDescription == "The password is invalid or the user does not have a password." {
                    errorMessage = "Email or password cannot be empty"
                } else if error!.localizedDescription == "The email address is badly formatted." {
                    errorMessage = "Please provide a valid email address"
                } else if error!.localizedDescription == "The supplied auth credential is malformed or has expired." {
                    errorMessage = "Incorrect email or password. Please try again."
                }
                showErrorMessage = true
                return
            }
            guard let user = result?.user else { return }
            
            fetchUserData(userId: user.uid)
        }
    }
    
    func fetchUserData(userId: String) {
        Firestore.firestore().collection("user").document(userId).getDocument { document, error in
            if let error = error {
                // Log the error or update the UI to inform the user
                print("Error fetching user data: \(error.localizedDescription)")
                self.errorMessage = "Failed to fetch user data. Please try again."
                self.showErrorMessage = true
                return
            }
            
            if let user = try? document?.data(as: UserModel.self) {
                // Update the userViewModel with the retrieved user data
                userViewModel.currentUser = user
            }
//
            loginSuccessful = true
        }
    }
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        let userViewModel = UserViewModel()
        LoginView().environmentObject(userViewModel)
    }
}
