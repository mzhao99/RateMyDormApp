//
//  CreateAccountView.swift
//  RateMyDorm
//
//  Created by 田诗韵 on 12/13/23.
//

import SwiftUI



struct CreateUserView: View {
    @StateObject var viewModel = UniversityListViewModel()
    @State private var username: String = ""
    @State private var selectedUniversity: String?
    @State private var showDropdown = false
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 15) {
                Text("RateMyDorm")
                    .font(.largeTitle)
                    .foregroundColor(Color.teal)
                    .padding(.vertical, 10)
                
                TextField("Create your Username", text: $username)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(UIColor.lightGray), lineWidth: 1.5)
                    )
                
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
                            ForEach(viewModel.universities, id: \.self) { university in
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

                
                Button(action: {
                    // Logic to create an account
                }) {
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
                .padding(.top, 20)
                
                Spacer()
            }
            .padding()
            .navigationBarTitle("Create Account", displayMode: .inline)
            .onAppear {
                if viewModel.universities.isEmpty {
                    viewModel.fetchUniversityDataIfNeeded()
                }
            }
        }
    }
}

struct CreateUserView_Previews: PreviewProvider {
    static var previews: some View {
        CreateUserView()
    }
}


