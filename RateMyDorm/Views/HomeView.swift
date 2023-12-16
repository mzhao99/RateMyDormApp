//
//  HomeView.swift
//  RateMyDorm
//
//  Created by Manling Zhao on 12/9/23.
//

import SwiftUI
import FirebaseFirestoreSwift
import FirebaseFirestore

struct Dorm: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var universityName: String
    var overallRating: Double
    var numOfReviews: Int
    var reviews: [String]
    var photos: [String]
    var roomRating: Double
    var buildingRating: Double
    var locationRating: Double
    var bathroomRating: Double
    var numOfClassYears: Int
    var freshman: Int
    var sophomore: Int
    var junior: Int
    var senior: Int
    var graduate: Int
}

struct HomeView: View {
    @State private var searchText = ""
    @State private var isSearching = false
    @State private var dorms = [Dorm]()
    @Binding var universityName: String
    
    // filtered search results
    private var filteredDorms: [Dorm] {
        if searchText.isEmpty {
            return dorms
        } else {
            return dorms.filter { dorm in
                return dorm.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(filteredDorms) { dorm in
                    NavigationLink(destination: DormDetailView(dormName: .constant(dorm.name), overallRating: .constant(dorm.overallRating), roomRating: .constant(dorm.roomRating), buildingRating: .constant(dorm.buildingRating), locationRating: .constant(dorm.locationRating), bathroomRating: .constant(dorm.bathroomRating), numOfReviews: .constant(dorm.numOfReviews), reviews: .constant(dorm.reviews), photos: .constant(dorm.photos), numOfClassYears: .constant(dorm.numOfClassYears), freshman: .constant(dorm.freshman), sophomore: .constant(dorm.sophomore), junior: .constant(dorm.junior), senior: .constant(dorm.senior), graduate: .constant(dorm.graduate))) {
                        HStack {
                            // dorm image
                            AsyncImage(url: URL(string: dorm.photos.first ?? "https://www.ratemydorm.com/_next/image?url=%2Fimg%2Fdorm-square.jpg&w=1920&q=75")) { image in image
                                    .resizable()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 120, height: 100)
                            .cornerRadius(10)
                            .padding(.vertical, 10)
                            
                            //dorm title and rating
                            VStack(alignment: .leading) {
                                // dorm name
                                Text(dorm.name)
                                    .bold()
                                    .lineLimit(1)
                                    .padding(.vertical, 3)
                                    .font(.system(size: 18, design: .rounded))
                                HStack {
                                    // dorm overall rating
                                    StarRatingView(rating: dorm.overallRating, maxRating: 5)
                                        .frame(width: 80)
                                    // number of reviews
                                    Text("\(dorm.numOfReviews) reviews")
                                        .font(.system(size: 14, design: .rounded))
                                        .foregroundColor(Color(UIColor.gray))
                                }
                            }
                            .padding(.leading, 5)
                        }
                    }
                    .listRowInsets(EdgeInsets())
                }
            }
            .background(.white)
            .scrollContentBackground(.hidden)
            .searchable(text: $searchText, prompt: "Search Dorm")
            .navigationBarTitle("Northeastern Dorms", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .onAppear {
                fetchDorms()
            }
        }
    }
    
    private func fetchDorms() {
        let db = Firestore.firestore()
        db.collection("dorm")
            .whereField("universityName", isEqualTo: universityName)
            .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else {
                    print("Error fetching documents: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                dorms = documents.compactMap { document in
                    do {
                        return try document.data(as: Dorm.self)
                    } catch {
                        print("Error decoding dorm: \(error.localizedDescription)")
                        return nil
                    }
                }
            }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(universityName: .constant("Northeastern University"))
    }
}
