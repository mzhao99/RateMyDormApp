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
    
    private var filteredDorms: [String] {
        if searchText.isEmpty {
            return allDorms
        } else {
            return allDorms.filter { $0.localizedCaseInsensitiveContains(searchText) }
        }
    }

    private let allDorms = ["377 Hungtington Ave", "Item 2", "Item 3", "Item 4", "Item 5", "Item 6", "Item 7", "Item 8", "Item 9", "Item 10"]
    
    private let subtitles = ["Sub 1", "Sub 2", "Sub 3", "Sub 4", "Sub 5", "Sub 6", "Sub 7", "Sub 8", "Sub 9", "Sub 10"]
    
    private let photos = [""]
    
    private let ratings = [2.3, 5, 4.5, 3.4, 4.2, 2.3, 5, 4.5, 3.4, 4.2]
    private let numRatings = [2, 8, 10, 6, 14, 3, 8, 10, 6, 14]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(0..<allDorms.count, id: \.self) { num in
                    HStack() {
                        // dorm image
                        AsyncImage(url: URL(string: "https://cc-prod.scene7.com/is/image/CCProdAuthor/d-03-4?$pjpeg$&jpegSize=200&wid=720")) { image in image
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
                            Text(allDorms[num])
                                .bold()
                                .lineLimit(1)
                                .padding(.vertical, 3)
                                .font(.system(size: 18, design: .rounded))
                            HStack {
                                // dorm overall rating
                                StarRatingView(rating: ratings[num], maxRating: 5)
                                    .frame(width: 80)
                                // number of reviews
                                Text("\(numRatings[num]) reviews")
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
