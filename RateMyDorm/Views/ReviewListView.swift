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

class ReviewListViewModel: ObservableObject {
    @Published var reviews: [Review] = []

    private var db = Firestore.firestore()

    init() {
        fetchReviews()
    }
    
    func fetchReviews() {
            db.collection("review").getDocuments { [weak self] (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    let items = querySnapshot?.documents.compactMap { document -> Review? in
                        try? document.data(as: Review.self)
                    }
                    DispatchQueue.main.async {
                        self?.reviews = items ?? []
                    }
                }
            }
        }
    
    func deleteReview(_ review: Review) {
        db.collection("review").document(review.id!).delete { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
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

// Placeholder for StarRatingView
//struct StarRatingView: View {
//    var rating: Double
//    var maxRating: Int
//
//    var body: some View {
//        Text("★ \(rating)/\(maxRating)")
//            .foregroundColor(.yellow)
//    }
//}

struct ReviewListView: View {
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
        ReviewListView()
    }
}



