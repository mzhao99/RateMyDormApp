//
//  BlogCardView.swift
//  RateMyDorm
//
//  Created by Manling Zhao on 12/12/23.
//

import SwiftUI

struct BlogCardView: View {
    @Binding var title: String
    @Binding var description: String
    @Binding var photo: String?
    
    var body: some View {
        VStack(alignment: .leading) {
            // Image Section
            if let photo = photo, let imageURL = URL(string: photo) {
                AsyncImage(url: imageURL) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: UIScreen.main.bounds.width - 40, height: 170)
                            .clipped()
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
            else {
                //Placeholder image for missing image data
                Image("test_image")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 170)
                    .clipped()
            }

            // Text Section
            VStack(alignment: .leading) {
                Text(title)
                    .font(.title3)
                    .bold()
                    .padding(.bottom, 1)
                Text(description)
                    .foregroundColor(.secondary)
                    .lineLimit(3)
                    .padding(.bottom, 5)
            }
            .padding()
        }
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 3)
        .padding(.horizontal)
    }
}

struct BlogCardView_Previews: PreviewProvider {
    static var previews: some View {
        BlogCardView(title: .constant("Blog Title"), description: .constant("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book."), photo: .constant("https://www.bu.edu/housing/files/2019/12/18-1773-HUB1-166-1500x624.jpg"))
    }
}
