//
//  CreateAccountView.swift
//  RateMyDorm
//
//  Created by 田诗韵 on 12/13/23.
//

import SwiftUI

struct CreateAccountView: View {
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var emailError = ""
    @State private var passwordError = ""
    var body: some View {
        VStack(spacing: 15) {
            Text("RateMyDorm")
                .font(.largeTitle)
                .foregroundColor(Color.teal)
            
            TextField("Username", text: $name)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(5.0)
                .padding(.bottom, 20)
            
            TextField("Email", text: $email)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(5.0)
                .padding(.bottom, 20)
            
            if !emailError.isEmpty {
                            Text(emailError)
                                .foregroundColor(.red)
                                .padding(.bottom, 15)
                        }
            
            SecureField("Password", text: $password)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(5.0)
                .padding(.bottom, 20)
            
            if !passwordError.isEmpty {
                            Text(passwordError)
                                .foregroundColor(.red)
                                .padding(.bottom, 15)
                        }
            
            Button(action: createAcoount) {
                Text("Create")
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .frame(height: 50)
                    .foregroundColor(.white)
                    .font(.system(size: 14, weight: .bold))
                    .background(Color.teal)
                    .cornerRadius(5)
            }
        }
        .padding()
        
       
    }
    func createAcoount(){
        // Reset errors
                emailError = ""
                passwordError = ""
                
                // Validate email and password
                if !isValidEmail(email) {
                    emailError = "Invalid email"
                }
                
                if password.count < 6 {
                    passwordError = "Password should be no less than 6 characters"
                }

                // Proceed with account creation if no errors
                if emailError.isEmpty && passwordError.isEmpty {
                    // Account creation logic here
                }
        
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }

}



#Preview {
    CreateAccountView()
}
