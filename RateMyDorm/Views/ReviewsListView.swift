//
//  SwiftUIView.swift
//  RateMyDorm
//
//  Created by 田诗韵 on 12/15/23.
//
import SwiftUI
import Firebase
import FirebaseFirestoreSwift
import FirebaseFirestore



struct ReviewModel: Identifiable, Codable {
    @DocumentID var id: String?
    var timeStamp: Date
    var universityName: String
    var overallRating: Double
    var comment: String
    var dormName: String
}

import SwiftUI

struct ReviewsListView: View {
    @EnvironmentObject var userViewModel: UserViewModel

    var body: some View {
        VStack {
            if userViewModel.reviews.isEmpty {
                Text("You don't have a review yet.")
            } else {
                List(userViewModel.reviews) { review in
                    VStack(alignment: .leading) {
                        Text(review.universityName).bold()
                        Text("Rating: \(review.overallRating, specifier: "%.1f")")
                        Text(review.comment)
                        Text("Dorm: \(review.dormName)")
                        Text("Date: \(review.timeStamp, formatter: dateFormatter)")
                    }
                }
            }
        }
        .onAppear {
            userViewModel.fetchUserReviews()
        }
    }
}

let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()



extension UserViewModel {
    static var preview: UserViewModel {
        let mockViewModel = UserViewModel()
        // Create some mock reviews
        mockViewModel.reviews = [
            ReviewModel(id: "1", timeStamp: Date(), universityName: "University A", overallRating: 4.5, comment: "Great experience!", dormName: "Dorm A"),
            ReviewModel(id: "2", timeStamp: Date(), universityName: "University B", overallRating: 3.8, comment: "Good, but room for improvement.", dormName: "Dorm B")
        ]
        return mockViewModel
    }
}
struct ReviewsListView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewsListView()
            .environmentObject(UserViewModel.preview)
    }
}
