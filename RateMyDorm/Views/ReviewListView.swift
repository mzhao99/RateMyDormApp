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

struct Review: Identifiable, Codable {
    @DocumentID var id: String?
    var dormName: String
    var overallRating: Int
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

class ReviewListViewModel: ObservableObject {
    @Published var reviews: [Review] = []
    @EnvironmentObject var userViewModel: UserViewModel

    private var db = Firestore.firestore()

    init() {
        fetchReviews()
    }
    
    func fetchReviews() {
            guard let currentUser = userViewModel.currentUser else { return }
            
            let reviewIds = currentUser.reviewIds  // Assuming this is how you access review IDs
            let reviewCollection = db.collection("review")

            for reviewId in reviewIds {
                reviewCollection.document(reviewId).getDocument { [weak self] (document, error) in
                    if let document = document, document.exists {
                        if let review = try? document.data(as: Review.self) {
                            DispatchQueue.main.async {
                                self?.reviews.append(review)
                            }
                        }
                    } else {
                        print("Document does not exist")
                    }
                }
            }
        }
    
    func deleteReview(_ review: Review) {
        guard let reviewId = review.id, let userId = userViewModel.currentUser?.id else { return }

        let userDocument = db.collection("users").document(userId)
        let reviewDocument = db.collection("review").document(reviewId)

        // Begin a batch write to ensure atomicity
        let batch = db.batch()

        // Delete the review document
        batch.deleteDocument(reviewDocument)

        // Update the user document to remove the reviewId from reviewIds
        batch.updateData(["reviewIds": FieldValue.arrayRemove([reviewId])], forDocument: userDocument)

        // Commit the batch write
        batch.commit { err in
            if let err = err {
                print("Error writing batch \(err)")
            } else {
                print("Batch write succeeded.")
                self.fetchReviews() // Refresh the list after deletion
            }
        }
    }

}

struct ReviewCell: View {
    let review: Review
    var deleteAction: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(review.dormName)
                .font(.headline)
                .bold()
            
            // Display ratings using your StarRatingView (or similar)
            HStack {
                VStack(alignment: .leading) {
                    Text("Room Rating:")
                    StarRatingView(rating: Double(review.roomRating), maxRating: 5)
                }
                
                Spacer()
                
                VStack(alignment: .leading) {
                    Text("Building Rating:")
                    StarRatingView(rating: Double(review.buildingRating), maxRating: 5)
                }
            }
            
            // Display comment
            Text("Comment:")
                .bold()
            Text(review.comment)
                .fixedSize(horizontal: false, vertical: true)

            // Display the image (if available)
            if let photoUrl = review.photo, let url = URL(string: photoUrl) {
                AsyncImage(url: url) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 180, height: 100)
                .cornerRadius(8)
            }

            // Delete button
            Button(action: deleteAction) {
                HStack {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                    Text("Delete")
                        .foregroundColor(.red)
                }
            }
            .padding(.top, 8)
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 1)
    }
}



struct ReviewListView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @ObservedObject var viewModel = ReviewListViewModel()

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.reviews) { review in
                    ReviewCell(review: review, deleteAction: {
                        viewModel.deleteReview(review)
                    })
                }
            }
            .navigationBarTitle("My Reviews", displayMode: .inline)
        }
    }
}

struct ReviewListView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewListView().environmentObject(UserViewModel())
    }
}



