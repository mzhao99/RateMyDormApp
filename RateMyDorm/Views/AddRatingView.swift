//
//  AddReviewView.swift
//  RateMyDorm
//
//  Created by Manling Zhao on 12/9/23.
//

import SwiftUI

struct AddRatingView: View {
    @Binding var showAddRating: Bool
    @State private var showDropdown = false
    @State private var selected = "Select a dorm"
    @State private var dormSelected = false
    @State private var showSecondView = false
        
    private let dorms = ["Dorm 1", "Dorm 2", "Dorm 3", "Dorm 4", "Dorm 5", "Dorm 6"]
    
    var body: some View {
        Spacer().fullScreenCover(isPresented: $showAddRating, content: {
            NavigationStack {
                VStack {
                    // cancel button
                    HStack {
                        Button(action: {
                            // clear all the states
                            selected = "Select a dorm"
                            showDropdown = false
                            dormSelected = false
                            showAddRating.toggle()
                        }, label: {
                            Text("Cancel")
                        })
                        Spacer()
                    }
                    
                    Spacer()
                    
                    ZStack {
                        // dropdown list
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                            ScrollView {
                                VStack(spacing: 20) {
                                    ForEach(0..<dorms.count, id: \.self) { num in
                                        Button {
                                            withAnimation{
                                                selected = dorms[num]
                                                showDropdown.toggle()
                                                dormSelected = true
                                            }
                                        } label: {
                                            Text(dorms[num]).foregroundColor(.black)
                                            Spacer()
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                                .padding(.vertical, 15)
                            }
                        }
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(lineWidth: 2)
                                .foregroundColor(.gray)
                        }
                        .frame(height: showDropdown ? 220 : 50)
                        .offset(y: showDropdown ? 0 : -145)
                        .foregroundColor(.white)
                        
                        // main selection box
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .frame(height: 55)
                                .foregroundColor(.white)
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 2)
                                .frame(height: 50)
                            HStack {
                                Text(selected)
                                    .font(.system(size: 20, design: .rounded))
                                    .foregroundColor(selected == "Select a dorm" ? .gray : .black)
                                Spacer()
                                Image(systemName: "chevron.right").rotationEffect(.degrees(showDropdown ? 90 : 0))
                            }
                            .bold()
                            .padding()
                        }
                        .offset(y: -145)
                        .onTapGesture {
                            withAnimation {
                                showDropdown.toggle()
                            }
                        }
                    }
                    
                    Spacer()
                    
                    // 'continue' button
                    HStack {
                        Spacer()
                        if dormSelected {
                            Button(action: {
                                showSecondView = true
                            }, label: {
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 20))
                                    .foregroundColor(.white)
                                    .frame(width: 50, height: 50)
                                    .background(.teal)
                                    .cornerRadius(30)
                            })
                        }
                    }
                }
                .padding(.leading, 30)
                .padding(.trailing, 30)
                .navigationDestination(isPresented: $showSecondView) {
                    AddRatingSecondView(showSecondView: $showSecondView, selectedDorm: $selected)
                }
            }
        })
    }
}

struct AddRatingView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewWrapper()
    }

    struct PreviewWrapper: View {
        @State private var showAddRating = true

        var body: some View {
            AddRatingView(showAddRating: $showAddRating)
        }
    }
}
