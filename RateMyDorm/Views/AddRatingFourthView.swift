//
//  AddRatingFourthView.swift
//  RateMyDorm
//
//  Created by Manling Zhao on 12/12/23.
//

import SwiftUI

struct AddRatingFourthView: View {
    @Binding var selectedDorm: String
    @Binding var roomRating: Int
    @Binding var buildingRating: Int
    @Binding var bathroomRating: Int
    @Binding var locationRating: Int
    @Binding var comment: String
    @Binding var photo: Data?
    @Binding var universityName: String
    
    @State private var showFinalView = false
    @State private var classYears = ["Freshman", "Sophomore", "Junior", "Senior", "Graduate Student"]
    @State private var selectedClassYears = Array(repeating: false, count: 5)
    @State private var roomTypes = ["Single", "Double", "Triple", "Quad", "Suite", "Other"]
    @State private var selectedRoomTypes = Array(repeating: false, count: 6)
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ScrollView {
                    VStack(alignment: .leading) {
                        ProgressView(value: 0.75)
                            .tint(.teal)
                        
                        Text("Step 3: Class Years & Room Type")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .padding(.top, 5)
                        
                        Group {
                            Text("What class year(s) did you live here?")
                                .font(.title)
                                .bold()
                                .padding(.bottom, 5)
                                .padding(.top, 5)
                            
                            ForEach(0..<5) { index in
                                HStack {
                                    Button(action: {
                                        selectedClassYears[index].toggle()
                                    }) {
                                        Image(systemName: selectedClassYears[index] ? "checkmark.square.fill" : "square")
                                            .resizable()
                                            .frame(width: 25, height: 25)
                                            .foregroundColor(selectedClassYears[index] ? .teal : .gray)
                                    }
                                    Text(classYears[index])
                                        .padding(.horizontal, 5)
                                }
                                .padding(.bottom, 6)
                            }
                        }
                        
                        Group {
                            Text("What type of room(s) did you have?")
                                .font(.title)
                                .bold()
                                .padding(.bottom, 5)
                            
                            ForEach(0..<6) { index in
                                HStack {
                                    Button(action: {
                                        selectedRoomTypes[index].toggle()
                                    }) {
                                        Image(systemName: selectedRoomTypes[index] ? "checkmark.square.fill" : "square")
                                            .resizable()
                                            .frame(width: 25, height: 25)
                                            .foregroundColor(selectedRoomTypes[index] ? .teal : .gray)
                                    }
                                    Text(roomTypes[index])
                                        .padding(.horizontal, 5)
                                }
                                .padding(.bottom, 6)
                            }
                        }
                        
                        Spacer()
                    }
                    // V Stack padding
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
                            presentationMode.wrappedValue.dismiss()
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
                        if selectedClassYears.filter({$0}).count > 0 && selectedRoomTypes.filter({$0}).count > 0 {
                            NavigationLink(
                                destination: AddRatingFinalView(selectedDorm: $selectedDorm, roomRating: $roomRating, buildingRating: $buildingRating, bathroomRating: $bathroomRating, locationRating: $locationRating, comment: $comment, photo: $photo, selectedClassYears: $selectedClassYears, selectedRoomTypes: $selectedRoomTypes, universityName: $universityName),
                                isActive: $showFinalView,
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
}

struct AddRatingFourthView_Previews: PreviewProvider {
    static var previews: some View {
        AddRatingFourthView(selectedDorm: .constant("Dorm 1"), roomRating: .constant(4), buildingRating: .constant(4), bathroomRating: .constant(3), locationRating: .constant(5), comment: .constant("This is a comment"), photo: .constant(UIImage(systemName: "photo")?.jpegData(compressionQuality: 1.0)), universityName: .constant("Northeastern University"))
    }
}
