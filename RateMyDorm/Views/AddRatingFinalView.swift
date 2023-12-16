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
        
        var reviewRef: DocumentReference?
        // Add the review data to the "review" collection in Firestore
        reviewRef = Firestore.firestore().collection("review").addDocument(data: reviewData) { error in
            if let error = error {
                print("Error adding review to Firestore: \(error.localizedDescription)")
            } else {
                print("Review added to Firestore successfully")
                addReviewSuccessful = true
                
                updateDormWithReviewId(reviewRef?.documentID)
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
    
    func getNewRating(_ oldOverallRating: Double, _ oldCount: Int, _ newRating: Int) -> Double {
        let newAverageRating = ((oldOverallRating * Double(oldCount)) + Double(newRating)) / Double(oldCount + 1)
        return newAverageRating
    }
    
    func getNewRating(_ oldOverallRating: Double, _ oldCount: Int, _ newRating: Double) -> Double {
        let newAverageRating = ((oldOverallRating * Double(oldCount)) + Double(newRating)) / Double(oldCount + 1)
        return newAverageRating
    }
    
    func updateDormWithReviewId(_ reviewId: String?) {
        var oldOverallRating: Double = 0
        var oldRoomRating: Double = 0
        var oldBuildingRating: Double = 0
        var oldLocationRating: Double = 0
        var oldBathroomRating: Double = 0
        let oldNumOfReviews: Int = 0
        let base64String = photo?.base64EncodedString()
        
        let dormQuery = Firestore.firestore().collection("dorm").whereField("name", isEqualTo: selectedDorm)
        dormQuery.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching dorm documents: \(error.localizedDescription)")
            } else {
                // Check if any documents match the query
                if let document = querySnapshot?.documents.first {
                    // Access the dormRef for the matched document
                    let dormRef = Firestore.firestore().collection("dorm").document(document.documentID)
//                    print(document.documentID)
                    dormRef.getDocument { (document, error) in
                        if let document = document, document.exists {
                            oldOverallRating = document["overallRating"] as? Double ?? 0
                            oldRoomRating = document["roomRating"] as? Double ?? 0
                            oldBathroomRating = document["bathroomRating"] as? Double ?? 0
                            oldBuildingRating = document["buildingRating"] as? Double ?? 0
                            oldLocationRating = document["locationRating"] as? Double ?? 0
                            
                            let newOverallRating = getNewRating(oldOverallRating, oldNumOfReviews, calculateOverallRating())
                            let newRoomRating = getNewRating(oldRoomRating, oldNumOfReviews, roomRating)
                            let newBathroomRating = getNewRating(oldBathroomRating, oldNumOfReviews, bathroomRating)
                            let newBuildingRating = getNewRating(oldBuildingRating, oldNumOfReviews, buildingRating)
                            let newLocationRating = getNewRating(oldLocationRating, oldNumOfReviews, locationRating)
                            
                            // Update the array of reviewIds in the dorm document
                            dormRef.updateData([
                                "reviews": FieldValue.arrayUnion([reviewId!]),
                                "photos": FieldValue.arrayUnion([base64String ?? ""]),
                                "overallRating": newOverallRating,
                                "roomRating": newRoomRating,
                                "bathroomRating": newBathroomRating,
                                "locationRating": newLocationRating,
                                "buildingRating": newBuildingRating,
                                "freshman": FieldValue.increment(selectedClassYears[0] ? Int64(1) : Int64(0)),
                                "sophomore": FieldValue.increment(selectedClassYears[1] ? Int64(1) : Int64(0)),
                                "junior": FieldValue.increment(selectedClassYears[2] ? Int64(1) : Int64(0)),
                                "senior": FieldValue.increment(selectedClassYears[3] ? Int64(1) : Int64(0)),
                                "graduate": FieldValue.increment(selectedClassYears[4] ? Int64(1) : Int64(0)),
                                "numOfClassYears": FieldValue.increment(Int64(getSelectedClassYears().count)),
                                "numOfReviews": FieldValue.increment(Int64(1))
                            ]) { error in
                                if let error = error {
                                    print("Error updating dorm document: \(error.localizedDescription)")
                                } else {
                                    print("Dorm document updated successfully with review ID")
                                }
                            }
                        }
                    }
                } else {
                    print("No matching dorm documents found")
                }
                
                // Also update the reviewId field in user collection
                let userQuery = Firestore.firestore().collection("user").whereField("email", isEqualTo: userViewModel.currentUser?.email ?? "N/A")
                userQuery.getDocuments { (querySnapshot, error) in
                    if let error = error {
                        print("Error fetching user documents: \(error.localizedDescription)")
                    } else {
                        // Check if any documents match the query
                        if let document = querySnapshot?.documents.first {
                            // Access the dormRef for the matched document
                            let userRef = Firestore.firestore().collection("user").document(document.documentID)
                            
                            userRef.getDocument { (document, error) in
                                userRef.updateData([
                                    "reviewIds": FieldValue.arrayUnion([reviewId!]),
                                ]) { error in
                                    if let error = error {
                                        print("Error updating user document: \(error.localizedDescription)")
                                    } else {
                                        print("User document updated successfully with review ID")
                                    }
                                }
                            }
                        } else {
                            print("No matching user documents found")
                        }
                    }
                }
            }
        }

 
    }
}

struct AddRatingFinalView_Previews: PreviewProvider {
    static var previews: some View {
        let userViewModel = UserViewModel()
        AddRatingFinalView(selectedDorm: .constant("Dorm 1"), roomRating: .constant(4), buildingRating: .constant(4), bathroomRating: .constant(3), locationRating: .constant(5), comment: .constant("This is a very very very very very very very very very very very very very very long comment"), photo: .constant(UIImage(systemName: "photo")?.jpegData(compressionQuality: 1.0)), selectedClassYears: .constant([true, true, false, false, false]), selectedRoomTypes: .constant([true, false, false, true, false, false]), universityName: .constant("Northeastern University")).environmentObject(userViewModel)
    }
}
