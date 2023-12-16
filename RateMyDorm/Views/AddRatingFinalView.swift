//
//  AddRatingFinalView.swift
//  RateMyDorm
//
//  Created by Manling Zhao on 12/12/23.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift
import FirebaseFirestore

struct AddRatingFinalView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var userViewModel: UserViewModel
    @Binding var selectedDorm: String
    @Binding var roomRating: Int
    @Binding var buildingRating: Int
    @Binding var bathroomRating: Int
    @Binding var locationRating: Int
    @Binding var comment: String
    @Binding var photo: Data?
    @Binding var selectedClassYears: Array<Bool>
    @Binding var selectedRoomTypes: Array<Bool>
    @Binding var universityName: String
    
    @State private var classYears = ["Freshman", "Sophomore", "Junior", "Senior", "Graduate Student"]
    @State private var roomTypes = ["Single", "Double", "Triple", "Quad", "Suite", "Other"]
    @State private var addReviewSuccessful = false
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
                        
                        
                        // next page
                        Button(action: {
                            submitDataToDatabase()
                        }, label: {
                            Text("Submit")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                                .frame(width: 100, height: 50)
                                .background(.teal)
                                .cornerRadius(30)
                        })
                        
                        
//                        NavigationLink(
//                            destination: AddRatingSuccessView(),
//                            label: {
//                                Text("Submit")
//                                    .font(.system(size: 20))
//                                    .foregroundColor(.white)
//                                    .frame(width: 100, height: 50)
//                                    .background(.teal)
//                                    .cornerRadius(30)
//                            }
//                        )
//                        .onTapGesture {
//                            submitDataToDatabase()
//                        }
                    }
                }
                .padding()
                .padding(.horizontal, 10)
                .frame(minHeight: geometry.size.height)
                
                
                NavigationLink(
                    destination: AddRatingSuccessView().navigationBarHidden(true),
                    isActive: $addReviewSuccessful,
                    label: { EmptyView() }
                )
                .hidden()
            }
        }
        .navigationBarHidden(true)
    }
    
    func submitDataToDatabase() {
        print("Submitting data to the database")
        
        // Ensure that the current user is available
        guard let user = userViewModel.currentUser else {
            print("User data not available")
            return
        }
        
        let base64String = photo?.base64EncodedString()
        
        // Create a dictionary with the review data
        let reviewData: [String: Any] = [
            "dormName": selectedDorm,
            "overallRating": calculateOverallRating(),
            "roomRating": roomRating,
            "buildingRating": buildingRating,
            "bathroomRating": bathroomRating,
            "locationRating": locationRating,
            "classYears": getSelectedClassYears(),
            "roomTypes": getSelectedRoomTypes(),
            "comment": comment,
            "photo": base64String ?? "",
            "universityName": universityName,
            "userId": user.id!,
            "timeStamp": FieldValue.serverTimestamp()
        ]
        
        // Add the review data to the "reviews" collection in Firestore
        Firestore.firestore().collection("review").addDocument(data: reviewData) { error in
            if let error = error {
                print("Error adding review to Firestore: \(error.localizedDescription)")
            } else {
                print("Review added to Firestore successfully")
                addReviewSuccessful = true
            }
        }
    }
    
    func getSelectedClassYears() -> [String] {
        return zip(selectedClassYears, classYears).filter { $0.0 }.map { $0.1 }
    }
    
    func getSelectedRoomTypes() -> [String] {
        return zip(selectedRoomTypes, roomTypes).filter { $0.0 }.map { $0.1 }
    }
    
    func calculateOverallRating() -> Double {
        return (Double)(roomRating + buildingRating + locationRating + bathroomRating) / (Double)(4)
    }
}

struct AddRatingFinalView_Previews: PreviewProvider {
    static var previews: some View {
        let userViewModel = UserViewModel()
        AddRatingFinalView(selectedDorm: .constant("Dorm 1"), roomRating: .constant(4), buildingRating: .constant(4), bathroomRating: .constant(3), locationRating: .constant(5), comment: .constant("This is a very very very very very very very very very very very very very very long comment"), photo: .constant(UIImage(systemName: "photo")?.jpegData(compressionQuality: 1.0)), selectedClassYears: .constant([true, true, false, false, false]), selectedRoomTypes: .constant([true, false, false, true, false, false]), universityName: .constant("Northeastern University")).environmentObject(userViewModel)
    }
}
