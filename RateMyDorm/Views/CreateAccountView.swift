//
//  CreateAccountView.swift
//  RateMyDorm
//
//  Created by 田诗韵 on 12/13/23.
//

import SwiftUI



struct CreateUserView: View {
    @StateObject private var viewModel = UniversityListViewModel()
    @State private var username: String = ""
    @State private var selectedUniversityIndex: Int?

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Create your username")) {
                    TextField("Username", text: $username)
                    Picker("Choose Your University", selection: $selectedUniversityIndex) {
                        ForEach(0..<viewModel.universities.count, id: \.self) { index in
                            Text(self.viewModel.universities[index]).tag(index as Int?)
                        }
                    }
                }
                
                if viewModel.isLoading {
                    HStack {
                        Spacer()
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: Color.teal))
                        Spacer()
                    }
                }

                Button("Continue") {
                    // Handle continue action
                }
                .disabled(username.isEmpty || selectedUniversityIndex == nil)
            }
            .navigationBarTitle("Sign Up", displayMode: .inline)
            .onAppear {
                if viewModel.universities.isEmpty {
                    viewModel.fetchUniversityDataIfNeeded()
                }
            }
        }
        .accentColor(Color.teal)
        .alert(isPresented: .constant(viewModel.error != nil)) {
            Alert(title: Text("Error"), message: Text(viewModel.error?.localizedDescription ?? "Unknown error"), dismissButton: .default(Text("OK")))
        }
    }
}

struct CreateUserView_Previews: PreviewProvider {
    static var previews: some View {
        CreateUserView()
    }
}
