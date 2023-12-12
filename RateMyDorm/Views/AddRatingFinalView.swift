//
//  AddRatingFinalView.swift
//  RateMyDorm
//
//  Created by Manling Zhao on 12/12/23.
//

import SwiftUI

struct AddRatingFinalView: View {
    @Binding var selectedDorm: String
    @Binding var roomRating: Int
    @Binding var buildingRating: Int
    @Binding var bathroomRating: Int
    @Binding var locationRating: Int
    @Binding var comment: String
    @Binding var photo: Data?
    @Binding var selectedClassYears: Array<Bool>
    @Binding var selectedRoomTypes: Array<Bool>
    
    @State private var universityName = "Northeastern"
    @State private var classYears = ["Freshman", "Sophomore", "Junior", "Senior", "Graduate Student"]
    @State private var roomTypes = ["Single", "Double", "Triple", "Quad", "Suite", "Other"]
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ScrollView {
                    VStack(alignment: .leading) {
                        ProgressView(value: 1)
                            .tint(.teal)
                        
                        Text("Step 4: Review")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .padding(.top, 5)
                        
                        Text("Confirm your review for \(selectedDorm)")
                            .font(.title)
                            .bold()
                            .padding(.bottom, 5)
                            .padding(.top, 5)
                        
                        VStack(alignment: .leading) {
                            HStack(alignment: .top) {
                                VStack(alignment: .leading) {
                                    Group {
                                        Text("Room rating")
                                            .bold()
                                        StarRatingView(rating: Double(roomRating), maxRating: 5)
                                            .frame(width: 100)
                                    }
                                    Group {
                                        Text("Building rating")
                                            .padding(.top, 5)
                                            .bold()
                                        StarRatingView(rating: Double(buildingRating), maxRating: 5)
                                            .frame(width: 100)
                                    }
                                    Group {
                                        Text("Bathroom rating")
                                            .padding(.top, 5)
                                            .bold()
                                        StarRatingView(rating: Double(bathroomRating), maxRating: 5)
                                            .frame(width: 100)
                                    }
                                    Group {
                                        Text("Location rating")
                                            .padding(.top, 5)
                                            .bold()
                                        StarRatingView(rating: Double(locationRating), maxRating: 5)
                                            .frame(width: 100)
                                    }
                                }
                                Spacer()
                                VStack(alignment: .leading) {
                                    Group {
                                        Text("Class year(s)")
                                            .padding(.bottom, 3)
                                            .bold()
                                        Text(zip(selectedClassYears, classYears)
                                            .filter { $0.0 }
                                            .map { $0.1 }.joined(separator: ", "))
                                    }
                                    
                                    Group {
                                        Text("Room type(s)")
                                            .padding(.top, 1)
                                            .padding(.bottom, 3)
                                            .bold()
                                        Text(zip(selectedRoomTypes, roomTypes)
                                            .filter { $0.0 }
                                            .map { $0.1 }.joined(separator: ", "))
                                    }
                                }
                                Spacer()
                            }
                            .padding(.horizontal)
                            .padding(.top)
                            
                            VStack(alignment: .leading) {
                                Group {
                                    Text("Comment")
                                        .padding(.bottom, 2)
                                        .bold()
                                    Text(comment)
                                }
                                
                                if let photo, let uiImage = UIImage(data: photo) {
                                    Text("Photo")
                                        .padding(.top, 3)
                                        .bold()
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 180, height: 100)
                                        .padding(.vertical, 15)
                                }
                            }
                            .padding(.horizontal)
                            .padding(.bottom)
                            .padding(.top, 3)
                        }
                        .background(Color(red: 0.95, green: 0.95, blue: 0.96, opacity: 1))
                        .cornerRadius(15)
                        .padding(.bottom, 15)
                        
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
                        
                        Button(action: {
                            
                        }, label: {
                            Text("Submit")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                                .frame(width: 100, height: 50)
                                .background(.teal)
                                .cornerRadius(30)
                        })
                    }
                }
                .frame(minHeight: geometry.size.height)
                .padding()
                .padding(.horizontal, 10)
                .frame(minHeight: geometry.size.height)
            }
        }
        .navigationBarHidden(true)
    }
}

struct AddRatingFinalView_Previews: PreviewProvider {
    static var previews: some View {
        AddRatingFinalView(selectedDorm: .constant("Dorm 1"), roomRating: .constant(4), buildingRating: .constant(4), bathroomRating: .constant(3), locationRating: .constant(5), comment: .constant("This is a very very very very very very very very very very very very very very long comment"), photo: .constant(UIImage(systemName: "photo")?.jpegData(compressionQuality: 1.0)), selectedClassYears: .constant([true, true, false, false, false]), selectedRoomTypes: .constant([true, false, false, true, false, false]))
    }
}
