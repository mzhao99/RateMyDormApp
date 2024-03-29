//
//  CreateAccountView.swift
//  RateMyDorm
//
//  Created by 田诗韵 on 12/13/23.
//

import SwiftUI
import Firebase

struct CreateUserView: View {
    @StateObject var viewModel = UniversityListViewModel()
    @State private var email = ""
    @State private var password = ""
    @State private var username = ""
    @State private var selectedUniversity: String?
    @State private var showDropdown = false
    @State private var showErrorMessage = false
    @State private var errorMessage = ""
    @State private var registrationSuccessful = false
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var userViewModel: UserViewModel
    
    @State private var universities = [
        "Boston University",
        "Harvard University",
        "Massachusetts Institute of Technology (MIT)",
        "Northeastern University",
        "Tufts University",
        "University of Massachusetts Amherst",
        "Boston College",
        "Worcester Polytechnic Institute (WPI)",
        "Brandeis University",
        "University of Massachusetts Boston"
    ]
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 15) {
                Text("Create your account")
                    .font(.title)
                    .bold()
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
      
                TextField("Username", text: $username)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(UIColor.lightGray), lineWidth: 1.5)
                    )
                    .autocapitalization(.none)
                
                // Dropdown Button
                Button(action: {
                    self.showDropdown = true
                }) {
                    HStack {
                        Text(selectedUniversity ?? "Select a University")
                            .foregroundColor(selectedUniversity == nil ? .gray : .black)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 10, height: 10)
                    }
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(UIColor.lightGray), lineWidth: 1.5)
                )
                .popover(isPresented: $showDropdown) {
                    ScrollView {
                        VStack(alignment: .leading) {
                            ForEach(universities, id: \.self) { university in
                                Text(university)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .contentShape(Rectangle()) // Make sure the tap area includes empty space
                                    .onTapGesture {
                                        self.selectedUniversity = university
                                        self.showDropdown = false
                                    }
                                    .padding(.vertical, 10)
                            }
                        }
                        .frame(maxWidth: .infinity) // Use the maximum width available
                        .padding(.horizontal) // Add some padding on the sides
                    }
                    .frame(minWidth: 200, idealWidth: 250, maxWidth: 300, minHeight: 200, idealHeight: 500, maxHeight: 500) // Adjust these values as needed
                }
                
                if (showErrorMessage) {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }

                
                NavigationLink(
                    destination: HomeNavView().navigationBarHidden(true),
                    isActive: $registrationSuccessful,
                    label: { EmptyView() }
                )
                .hidden()
                
                
                Spacer()
               
                // previous page
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Back")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .frame(height: 50)
                        .foregroundColor(Color.teal)
                        .font(.system(size: 20, weight: .bold))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.teal, lineWidth: 2)
                        )
                })
                
                Button(action: {
                    register()
                }) {
                    Text("Create")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .frame(height: 50)
                        .foregroundColor(.white)
                        .background(Color.teal)
                        .font(.system(size: 20, weight: .bold))
                        .cornerRadius(20)
                }
            }
            .padding()
            .onAppear {
                if viewModel.universities.isEmpty {
                    viewModel.fetchUniversityDataIfNeeded()
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    func register() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if error != nil {
                if error!.localizedDescription == "The email address is badly formatted." {
                    errorMessage = "Please provide a valid email address"
                } else {
                    errorMessage = error!.localizedDescription
                }
                showErrorMessage = true
            } else if (username == "") {
                errorMessage = "Username cannot be empty"
                showErrorMessage = true
            } else if (selectedUniversity == "") {
                errorMessage = "Please select your university"
                showErrorMessage = true
            } else {
                showErrorMessage = false
                addUserToFirestore()
            }
        }
    }
    
    func addUserToFirestore() {
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }

        let user = UserModel(
            id: userId,
            username: username,
            email: email,
            forumIds: [],
            reviewIds: [],
            universityName: selectedUniversity ?? ""
        )

        // Add user to 'users' collection in Firestore
        do {
            // Add user to 'users' collection in Firestore
            try Firestore.firestore().collection("user").document(userId).setData(from: user)
            userViewModel.currentUser = user
            // User added to Firestore successfully
            registrationSuccessful = true
        } catch let error {
            // Handle error adding user to Firestore
            print("Error adding user to Firestore: \(error.localizedDescription)")
            errorMessage = "Failed to create account. Please try again."
            showErrorMessage = true
        }
    }
}

struct CreateUserView_Previews: PreviewProvider {
    static var previews: some View {
        let userViewModel = UserViewModel()
        CreateUserView().environmentObject(userViewModel)
    }
}


