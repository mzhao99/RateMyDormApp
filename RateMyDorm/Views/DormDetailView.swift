//
//  DormDetailView.swift
//  RateMyDorm
//
//  Created by Manling Zhao on 12/13/23.
//

import SwiftUI

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
                            ProgressView(value: Double(freshman) / Double(numOfClassYears) == 0 ? 1 : Double(numOfClassYears))
                                .frame(width: 120)
                                .scaleEffect(x: 1, y: 3, anchor: .center)
                                .tint(.teal)
                            Text("\(freshman)")
                        }
                        HStack {
                            Text("Sophomore")
                            Spacer()
                            ProgressView(value: Double(sophomore) / Double(numOfClassYears) == 0 ? 1 : Double(numOfClassYears))
                                .frame(width: 120)
                                .scaleEffect(x: 1, y: 3, anchor: .center)
                                .tint(.teal)
                            Text("\(sophomore)")
                        }
                        HStack {
                            Text("Junior")
                            Spacer()
                            ProgressView(value: Double(junior) / Double(numOfClassYears) == 0 ? 1 : Double(numOfClassYears))
                                .frame(width: 120)
                                .scaleEffect(x: 1, y: 3, anchor: .center)
                                .tint(.teal)
                            Text("\(junior)")
                        }
                        HStack {
                            Text("Senior")
                            Spacer()
                            ProgressView(value: Double(senior) / Double(numOfClassYears) == 0 ? 1 : Double(numOfClassYears))
                                .frame(width: 120)
                                .scaleEffect(x: 1, y: 3, anchor: .center)
                                .tint(.teal)
                            Text("\(senior)")
                        }
                        HStack {
                            Text("Graduate")
                            Spacer()
                            ProgressView(value: Double(graduate) / Double(numOfClassYears) == 0 ? 1 : Double(numOfClassYears))
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

            
            
            RatingCardView(overallRating: .constant(4.5), date: .constant("2023/12/22"), roomType: .constant("Single Room"), comment: .constant("I lived in a seventh floor single. It wasn’t huge, but definitely enough space for one person. I lived in a Hojo triple freshman year and there was no light but seventh floor facing the river was wonderful, you could MIT campus and there was plenty of natural light. AC/heating is an old unit, not like the thermostat in some of the lower floors, so I recommend buying an electric thermostat. The top floor study lounge is great, it has heating problems but is a great chill place to study. Honestly, you have the great location of East, the safety of a security guard, and the privacy of an apartment/bay state. It’s a super quiet and lowkey building. BU’s hidden gem!"), roomRating: .constant(4), buildingRating: .constant(3), locationRating: .constant(4), bathroomRating: .constant(2), photo: .constant("https://www.bu.edu/housing/files/2019/12/18-1773-HUB1-166-1500x624.jpg"))
                .padding(.bottom)
                .padding(.horizontal, 10)
        }
        .navigationBarTitle("\(dormName) Reviews", displayMode: .inline)
    }
}

//struct DormDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        DormDetailView()
//    }
//}
