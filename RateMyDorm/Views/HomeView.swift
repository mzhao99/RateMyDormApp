//
//  HomeView.swift
//  RateMyDorm
//
//  Created by Manling Zhao on 12/9/23.
//

import SwiftUI

struct HomeView: View {
    
    @State private var searchText = ""
    @State private var isSearching = false
    
    private let data: [[String: Any]] = [
        [
            "name": "377 Hungtington Ave",
            "subtitle": "Sub 1",
            "photo": "https://cc-prod.scene7.com/is/image/CCProdAuthor/d-03-4?$pjpeg$&jpegSize=200&wid=720",
            "rating": 2.3,
            "numRatings": 2
        ],
        [
            "name": "Item 2",
            "subtitle": "Sub 2",
            "photo": "https://cc-prod.scene7.com/is/image/CCProdAuthor/d-03-4?$pjpeg$&jpegSize=200&wid=720",
            "rating": 5.0,
            "numRatings": 8
        ],
        [
            "name": "Item 3",
            "subtitle": "Sub 3",
            "photo": "https://cc-prod.scene7.com/is/image/CCProdAuthor/d-03-4?$pjpeg$&jpegSize=200&wid=720",
            "rating": 4.5,
            "numRatings": 10
        ],
        [
            "name": "Item 4",
            "subtitle": "Sub 4",
            "photo": "https://cc-prod.scene7.com/is/image/CCProdAuthor/d-03-4?$pjpeg$&jpegSize=200&wid=720",
            "rating": 3.4,
            "numRatings": 6
        ],
        [
            "name": "Item 5",
            "subtitle": "Sub 5",
            "photo": "https://cc-prod.scene7.com/is/image/CCProdAuthor/d-03-4?$pjpeg$&jpegSize=200&wid=720",
            "rating": 4.2,
            "numRatings": 14
        ],
        [
            "name": "Item 6",
            "subtitle": "Sub 6",
            "photo": "https://cc-prod.scene7.com/is/image/CCProdAuthor/d-03-4?$pjpeg$&jpegSize=200&wid=720",
            "rating": 2.3,
            "numRatings": 3
        ],
        [
            "name": "Item 7",
            "subtitle": "Sub 7",
            "photo": "https://cc-prod.scene7.com/is/image/CCProdAuthor/d-03-4?$pjpeg$&jpegSize=200&wid=720",
            "rating": 5.0,
            "numRatings": 8
        ],
        [
            "name": "Item 8",
            "subtitle": "Sub 8",
            "photo": "https://cc-prod.scene7.com/is/image/CCProdAuthor/d-03-4?$pjpeg$&jpegSize=200&wid=720",
            "rating": 4.5,
            "numRatings": 10
        ],
        [
            "name": "Item 9",
            "subtitle": "Sub 9",
            "photo": "https://cc-prod.scene7.com/is/image/CCProdAuthor/d-03-4?$pjpeg$&jpegSize=200&wid=720",
            "rating": 3.4,
            "numRatings": 6
        ],
        [
            "name": "Item 10",
            "subtitle": "Sub 10",
            "photo": "https://cc-prod.scene7.com/is/image/CCProdAuthor/d-03-4?$pjpeg$&jpegSize=200&wid=720",
            "rating": 4.2,
            "numRatings": 14
        ]
    ]
    
    // filtered search results
    private var filteredDorms: [[String: Any]] {
        if searchText.isEmpty {
            return data
        } else {
            return data.filter { dorm in
                guard let name = dorm["name"] as? String else { return false }
                return name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(0..<filteredDorms.count, id: \.self) { num in
                    HStack() {
                        // dorm image
                        AsyncImage(url: URL(string: filteredDorms[num]["photo"] as? String ?? "")) { image in image
                                .resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 110, height: 90)
                        .cornerRadius(5)
                        .padding(.vertical, 5)

                        //dorm title and rating
                        VStack(alignment: .leading) {
                            // dorm name
                            Text(filteredDorms[num]["name"] as? String ?? "")
                                .bold()
                                .lineLimit(1)
                                .padding(.vertical, 3)
                                .font(.system(size: 18, design: .rounded))
                            HStack {
                                // dorm overall rating
                                StarRatingView(rating: filteredDorms[num]["rating"] as? Double ?? 0, maxRating: 5)
                                    .frame(width: 80)
                                // number of reviews
                                Text("\(filteredDorms[num]["numRatings"] as? Int ?? 0) reviews")
                                    .font(.system(size: 14, design: .rounded))
                                    .foregroundColor(Color(UIColor.gray))
                            }
                        }
                        .padding(.leading, 5)

                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(Color(UIColor.lightGray))
                    }
                    .listRowInsets(EdgeInsets())
                }
            }
            .background(.white)
            .scrollContentBackground(.hidden)
            .searchable(text: $searchText, prompt: "Search Dorm")
            .navigationTitle("Northeastern Dorms")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
