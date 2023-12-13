//
//  LoginView.swift
//  RateMyDorm
//
//  Created by 田诗韵 on 12/12/23.
//

import SwiftUI
import FBSDKLoginKit
import Firebase

struct FacebookLoginButton: UIViewRepresentable {
    func makeUIView(context: Context) -> FBLoginButton {
        let loginButton = FBLoginButton()
        loginButton.permissions = ["public_profile", "email"]
        return loginButton
    }

    func updateUIView(_ uiView: FBLoginButton, context: Context) {}
}

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var showErrorMessage = false
    @State private var errorMessage = ""

    var body: some View {
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

            SecureField("Password", text: $password)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(UIColor.lightGray), lineWidth: 1.5)
                )
            
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

            Button(action: {
                register()
            }) {
                Text("Create an account ")
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

            Spacer()
        }
        .padding()
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
            } else {
                showErrorMessage = false
            }
        }
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
            } else {
                showErrorMessage = false
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
