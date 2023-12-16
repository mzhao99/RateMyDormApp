//
//  RatingCardView.swift
//  RateMyDorm
//
//  Created by Manling Zhao on 12/15/23.
//

import SwiftUI

struct RatingCardView: View {
    @Binding var overallRating: Double
    @Binding var date: String
    @Binding var roomType: String
    @Binding var comment: String
    @Binding var roomRating: Int
    @Binding var buildingRating: Int
    @Binding var locationRating: Int
    @Binding var bathroomRating: Int
    @Binding var photo: String?
    @State private var showFullText = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    HStack {
                        OverallRatingComponentView(overallRating: $overallRating)
                            
                        VStack(alignment: .leading) {
                            Text("\(date)")
                                .padding(.vertical, 1)
                                .bold()
                            Text("\(roomType)")
                                .foregroundColor(Color(UIColor.gray))
                                .bold()
                        }
                        .padding(.leading, 20)
                    }
                       
                    Text("\(comment)")
                        .lineLimit(showFullText ? nil : 3)
                        .padding(.top, 5)
                        .padding(.bottom, 2)
                        
                    HStack {
                        Spacer()
                        Button(action: {
                            withAnimation {
                                showFullText.toggle()
                            }
                        }) {
                            Text(showFullText ? "Show Less" : "Show More")
                                .foregroundColor(.blue)
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Room")
                                .bold()
                            Spacer()
                            StarRatingView(rating: CGFloat(roomRating), maxRating: 5)
                                .frame(width: 100)
                                .padding(.trailing, 20)
                        }
                        HStack {
                            Text("Building")
                                .bold()
                            Spacer()
                            StarRatingView(rating: CGFloat(buildingRating), maxRating: 5)
                                .frame(width: 100)
                                .padding(.trailing, 20)
                        }
                        HStack {
                            Text("Location")
                                .bold()
                            Spacer()
                            StarRatingView(rating: CGFloat(locationRating), maxRating: 5)
                                .frame(width: 100)
                                .padding(.trailing, 20)
                        }
                        HStack {
                            Text("Bathroom")
                                .bold()
                            Spacer()
                            StarRatingView(rating: CGFloat(bathroomRating), maxRating: 5)
                                .frame(width: 100)
                                .padding(.trailing, 20)
                        }
                    }
                    .padding(.trailing, 80)
                    .padding(.bottom, 15)
                    
                    if let photo = photo, let imageURL = URL(string: photo) {
                        AsyncImage(url: imageURL) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 200, height: 200)
                                    .clipped()
                                    .cornerRadius(20)
                            case .failure(_):
                                ProgressView()
                                    .frame(height: 170)
                            case .empty:
                                ProgressView()
                                    .frame(height: 170)
                            @unknown default:
                                ProgressView()
                                    .frame(height: 170)
                            }
                        }
                    }
                }
                .padding()
            }
        }
        .background(
            Color.white // Set the background color to match your view's background
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: -5) // Add a shadow at the top
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)  // Add a shadow at the bottom
        )
        .padding(.horizontal)
    }
}

struct RatingCardView_Previews: PreviewProvider {
    static var previews: some View {
        RatingCardView(overallRating: .constant(4.5), date: .constant("2023/12/22"), roomType: .constant("Single Room"), comment: .constant("I lived in a seventh floor single. It wasn’t huge, but definitely enough space for one person. I lived in a Hojo triple freshman year and there was no light but seventh floor facing the river was wonderful, you could MIT campus and there was plenty of natural light. AC/heating is an old unit, not like the thermostat in some of the lower floors, so I recommend buying an electric thermostat. The top floor study lounge is great, it has heating problems but is a great chill place to study. Honestly, you have the great location of East, the safety of a security guard, and the privacy of an apartment/bay state. It’s a super quiet and lowkey building. BU’s hidden gem!"), roomRating: .constant(4), buildingRating: .constant(3), locationRating: .constant(4), bathroomRating: .constant(2), photo: .constant("https://www.bu.edu/housing/files/2019/12/18-1773-HUB1-166-1500x624.jpg"))
    }
}
