//
//  AddReviewView.swift
//  RateMyDorm
//
//  Created by Manling Zhao on 12/9/23.
//

import SwiftUI

struct AddRatingView: View {
    @Binding var showAddRating: Bool
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
    
    var body: some View {
        Spacer().fullScreenCover(isPresented: $showAddRating, content: {
            VStack {
                ZStack {
                    
                }
                
                // main content
                NavigationStack {
                    List {
                        ForEach(0..<allDorms.count, id: \.self) { num in
                            HStack() {
                                // dorm image
                                AsyncImage(url: URL(string: "https://cc-prod.scene7.com/is/image/CCProdAuthor/d-03-4?$pjpeg$&jpegSize=200&wid=720")) { image in image
                                    .resizable()
                                    .scaledToFit()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 100)
                                .cornerRadius(5)
                                    
                                //dorm title and rating
                                VStack(alignment: .leading) {
                                    Text(allDorms[num])
                                        .bold()
                                        .lineLimit(1)
                                        .padding(.vertical, 3)
                                    Text(subtitles[num])
                                        .lineLimit(1)
                                }
                                .padding(.leading, 5)
                                    
                                Spacer()
                                Image(systemName: "chevron.right")
                            }
                            .frame(height: 80)
                        }
                    }
                    .searchable(text: $searchText, prompt: "Search Dorm Name")
                    .navigationTitle("Add Review")
                    .navigationBarTitleDisplayMode(.inline)
                }
                
                Spacer()
                
                // back button
                Button(action: {
                    showAddRating.toggle()
                }, label: {
                    Image(systemName: "arrow.down")
                        .font(.system(size: 25))
                        .foregroundColor(.white)
                        .frame(width: 60, height: 60)
                        .background(.teal)
                        .cornerRadius(30)
                })
            }
        })
    }
}

struct AddRatingView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewWrapper()
    }

    struct PreviewWrapper: View {
        @State private var showAddRating = true

        var body: some View {
            AddRatingView(showAddRating: $showAddRating)
        }
    }
}
