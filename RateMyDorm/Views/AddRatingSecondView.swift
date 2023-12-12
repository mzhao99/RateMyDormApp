//
//  AddRatingSecondView.swift
//  RateMyDorm
//
//  Created by Manling Zhao on 12/11/23.
//

import SwiftUI

struct AddRatingSecondView: View {
    @State private var roomRating = 0
    @State private var buildingRating = 0
    @State private var bathroomRating = 0
    @State private var locationRating = 0
    @State private var showThirdView = false
    @Binding var showSecondView: Bool
    @Binding var selectedDorm: String
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ScrollView {
                    VStack(alignment: .leading) {
                        ProgressView(value: 0.25)
                            .tint(.teal)
                        
                        Text("Step 1: Rating")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .padding(.top, 5)
                        
                        Group {
                            Text("Rate the room")
                                .font(.title)
                                .bold()
                                .padding(.bottom, 1)
                                .padding(.top, 5)
                            
                            Text("Consider the room's look and feel")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            StarRatingPickerView(rating: $roomRating)
                                .frame(width: 180)
                        }
                        
                        Group {
                            Text("Rate the building")
                                .font(.title)
                                .bold()
                                .padding(.bottom, 1)
                                .padding(.top)
                            
                            Text("Consider the building's age and amenities")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            StarRatingPickerView(rating: $buildingRating)
                                .frame(width: 180)
                        }
                        
                        Group {
                            Text("Rate the bathroom")
                                .font(.title)
                                .bold()
                                .padding(.bottom, 1)
                                .padding(.top)
                            
                            Text("Consider the bathroom's cleanliness and modernness")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            StarRatingPickerView(rating: $bathroomRating)
                                .frame(width: 180)
                        }
                        
                        Group {
                            Text("Rate the location")
                                .font(.title)
                                .bold()
                                .padding(.bottom, 1)
                                .padding(.top)
                            
                            Text("Consider the location's convenience and safety")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            StarRatingPickerView(rating: $locationRating)
                                .frame(width: 180)
                        }
                        
                        Spacer()
                    }
                    // V Stack spacing
                    .padding()
                    .padding(.horizontal, 10)
                    .frame(minHeight: geometry.size.height)
                }
                .frame(width: geometry.size.width)
                
                // bottom buttons
                VStack {
                    Spacer()
                    HStack {
                        // previous page
                        Button(action: {
                            showSecondView = false
                        }, label: {
                            Image(systemName: "arrow.left")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                                .frame(width: 50, height: 50)
                                .background(.teal)
                                .cornerRadius(30)
                        })
                        Spacer()
                        // next page
                        if (showNextButton()){
                            NavigationLink(
                                destination: AddRatingThirdView(selectedDorm: $selectedDorm, roomRating: $roomRating, buildingRating: $buildingRating, bathroomRating: $bathroomRating, locationRating: $locationRating),
                                isActive: $showThirdView,
                                label: {
                                    Image(systemName: "arrow.right")
                                        .font(.system(size: 20))
                                        .foregroundColor(.white)
                                        .frame(width: 50, height: 50)
                                        .background(.teal)
                                        .cornerRadius(30)
                                }
                            )
                        }
                    }
                }
                .padding()
                .padding(.horizontal, 10)
                .frame(minHeight: geometry.size.height)
            }
        }
        .navigationBarHidden(true)
    }
    
    func showNextButton() -> Bool {
        if (roomRating > 0 && buildingRating > 0 && bathroomRating > 0 && locationRating > 0) {
            return true
        } else {
            return false
        }
    }
}

struct AddRatingSecondView_Previews: PreviewProvider {
    static var previews: some View {
        AddRatingSecondView(showSecondView: .constant(true), selectedDorm: .constant("Dorm 1"))
    }
}
