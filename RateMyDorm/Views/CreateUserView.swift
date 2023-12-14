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
    @State private var selectedUniversity: String = "Select University"
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
                
                Button(action: { showDropdown = true }) {
                                HStack {
                                    Text(selectedUniversity)
                                        .foregroundColor(.black)

                                    Spacer()

                                    Image(systemName: "chevron.down")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 10, height: 10)
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color(UIColor.lightGray), lineWidth: 1.5)
                                )
                            }
                            .popover(isPresented: $showDropdown) {
                                List(viewModel.universities, id: \.self) { university in
                                    Text(university).onTapGesture {
                                        selectedUniversity = university
                                        showDropdown = false
                                    }
                                }
                            }

                            if viewModel.isLoading {
                                ProgressView()
                            } else if let error = viewModel.error {
                                Text("Error: \(error.localizedDescription)")
                                    .foregroundColor(.red)
                            }

                Button(action: {
                    // We need to finish this logic later
                    //
                    //
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

                            Spacer()
                        }
                        .padding()
                        .onAppear {
                            viewModel.fetchUniversityDataIfNeeded()
                        }
                    }
                }
}


struct CreateUserView_Previews: PreviewProvider {
    static var previews: some View {
        CreateUserView()
    }
}
