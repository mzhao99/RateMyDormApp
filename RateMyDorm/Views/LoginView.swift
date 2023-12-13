//
//  LoginView.swift
//  RateMyDorm
//
//  Created by 田诗韵 on 12/12/23.
//

import SwiftUI
import FBSDKLoginKit




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

    var body: some View {
        VStack(spacing: 15) {
            Text("RateMyDorm")
                .font(.largeTitle)
                .foregroundColor(Color.teal)

            TextField("Email", text: $email)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(5.0)
                .padding(.bottom, 20)

            SecureField("Password", text: $password)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(5.0)
                .padding(.bottom, 20)

            Button(action: login) {
                Text("Log In")
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .frame(height: 50)
                    .foregroundColor(.white)
                    .font(.system(size: 14, weight: .bold))
                    .background(Color.teal)
                    .cornerRadius(5)
            }


                Button(action: register) {
                    Text("Create an account ")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .frame(height: 50)
                        .foregroundColor(Color.teal)
                        .font(.system(size: 14, weight: .bold))
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
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
        // Implement your login logic here
    }

    func register() {
        // Implement your registration logic here
    }
}


//#Preview {
//    LoginView()
//}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
