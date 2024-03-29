//
//  DormDetailView.swift
//  RateMyDorm
//
//  Created by Manling Zhao on 12/13/23.
//

import SwiftUI
import FirebaseFirestoreSwift
import FirebaseFirestore

struct Review: Identifiable, Codable {
    @DocumentID var id: String?
    var dormName: String
    var overallRating: Double
    var roomRating: Int
    var buildingRating: Int
    var bathroomRating: Int
    var locationRating: Int
    var classYears: [String]
    var roomTypes: [String]
    var comment: String
    var photo: String?
    var universityName: String
    var userId: String
    var timeStamp: Timestamp
}


struct DormDetailView: View {
    @Binding var dormName: String
    @Binding var overallRating: Double
    @Binding var roomRating: Double
    @Binding var buildingRating: Double
    @Binding var locationRating: Double
    @Binding var bathroomRating: Double
    @Binding var numOfReviews: Int
    @Binding var reviews: [String]
    @Binding var photos: [String]
    @Binding var numOfClassYears: Int
    @Binding var freshman: Int
    @Binding var sophomore: Int
    @Binding var junior: Int
    @Binding var senior: Int
    @Binding var graduate: Int
    @State private var reviewDetails: [Review] = []
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Group {
                    Text("Overall Rating")
                        .font(.title)
                        .bold()
                    
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(.teal)
                        Text(String(format: "%.1f", overallRating))
                            .bold()
                    }
                    .font(.system(size: 30))
                    .padding(.bottom, 10)
                }
                
                Group {
                    Text("Rating Breakdown")
                        .bold()

                    VStack(alignment: .leading) {
                        HStack {
                            Text("Room")
                            Spacer()
                            StarRatingView(rating: roomRating, maxRating: 5)
                                .frame(width: 130)
                                .padding(.trailing, 20)
                        }
                        HStack {
                            Text("Building")
                            Spacer()
                            StarRatingView(rating: buildingRating, maxRating: 5)
                                .frame(width: 130)
                                .padding(.trailing, 20)
                        }
                        HStack {
                            Text("Location")
                            Spacer()
                            StarRatingView(rating: locationRating, maxRating: 5)
                                .frame(width: 130)
                                .padding(.trailing, 20)
                        }
                        HStack {
                            Text("Bathroom")
                            Spacer()
                            StarRatingView(rating: bathroomRating, maxRating: 5)
                                .frame(width: 130)
                                .padding(.trailing, 20)
                        }
                    }
                    .padding(.bottom, 15)
                }

                Group {
                    Text("When They Lived Here")
                        .bold()

                    VStack(alignment: .leading) {
                        HStack {
                            Text("Freshman")
                            Spacer()
                            ProgressView(value: Double(freshman) / Double(numOfClassYears))
                                .frame(width: 120)
                                .scaleEffect(x: 1, y: 3, anchor: .center)
                                .tint(.teal)
                            Text("\(freshman)")
                        }
                        HStack {
                            Text("Sophomore")
                            Spacer()
                            ProgressView(value: Double(sophomore) / Double(numOfClassYears))
                                .frame(width: 120)
                                .scaleEffect(x: 1, y: 3, anchor: .center)
                                .tint(.teal)
                            Text("\(sophomore)")
                        }
                        HStack {
                            Text("Junior")
                            Spacer()
                            ProgressView(value: Double(junior) / Double(numOfClassYears))
                                .frame(width: 120)
                                .scaleEffect(x: 1, y: 3, anchor: .center)
                                .tint(.teal)
                            Text("\(junior)")
                        }
                        HStack {
                            Text("Senior")
                            Spacer()
                            ProgressView(value: Double(senior) / Double(numOfClassYears))
                                .frame(width: 120)
                                .scaleEffect(x: 1, y: 3, anchor: .center)
                                .tint(.teal)
                            Text("\(senior)")
                        }
                        HStack {
                            Text("Graduate")
                            Spacer()
                            ProgressView(value: Double(graduate) / Double(numOfClassYears))
                                .frame(width: 120)
                                .scaleEffect(x: 1, y: 3, anchor: .center)
                                .tint(.teal)
                            Text("\(graduate)")
                        }
                    }
                    .padding(.bottom, 15)
                }

                Text("Browse \(numOfReviews) Reviews")
                    .bold()
            }
            .padding()
            .padding(.leading, 10)
            .padding(.trailing, 80)
            .padding(.bottom, 0)
            
            
            ForEach(reviewDetails) { review in
                RatingCardView(overallRating: .constant(review.overallRating), date: .constant("12/16/2023"), roomType: .constant(review.roomTypes.count == 1 ? "\(review.roomTypes[0]) Room" : "Multiple Room"), comment: .constant(review.comment), roomRating: .constant(review.roomRating), buildingRating: .constant(review.buildingRating), locationRating: .constant(review.locationRating), bathroomRating: .constant(review.bathroomRating), photo: .constant(review.photo))
                    .padding(.bottom)
                    .padding(.horizontal, 10)
            }
            
        }
        .navigationBarTitle("\(dormName) Reviews", displayMode: .inline)
        .onAppear{
            fetchReviews()
        }
    }
    
    func fetchReviews() {
        let db = Firestore.firestore()
        for id in reviews {
            db.collection("review").document(id).getDocument { snapshot, error in
                if let review = try? snapshot?.data(as: Review.self) {
                    self.reviewDetails.append(review)
                } else if let error = error {
                    print(error)
                }
            }
        }
    }
}

//struct DormDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        DormDetailView()
//    }
//}
