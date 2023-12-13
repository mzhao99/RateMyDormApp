//
//  BlogCardView.swift
//  RateMyDorm
//
//  Created by Manling Zhao on 12/12/23.
//

import SwiftUI

struct BlogCardView: View {
    @Binding var title: String
    @Binding var author: String
    @Binding var description: String
    @Binding var photo: Data?
    
    var body: some View {
        VStack(alignment: .leading) {
            // Image Section
            if let photoData = photo, let uiImage = UIImage(data: photoData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 170)
                    .clipped()
            } else {
                // Placeholder image for missing image data
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
                    .padding(.bottom, 0.05)
                Text("by \(author)")
                    .foregroundColor(.secondary)
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
        BlogCardView(title: .constant("Blog Title"), author: .constant("Author Name"), description: .constant("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book."), photo: .constant(nil))
    }
}
