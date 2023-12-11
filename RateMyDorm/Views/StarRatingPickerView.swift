//
//  StarRatingPickerView.swift
//  RateMyDorm
//
//  Created by Manling Zhao on 12/11/23.
//

import SwiftUI

struct StarRatingPickerView: View {
    @Binding var rating: Int
    
    var offImage: Image?
    var onImage = Image(systemName: "star.fill")
    
    var body: some View {
        HStack {
            ForEach(1..<6, id: \.self) { number in
                Button {
                    rating = number
                } label: {
                    image(for: number)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(number > rating ? Color(UIColor.lightGray) : Color.teal)
                }
            }
        }
    }
    
    func image(for number: Int) -> Image {
        if number > rating {
            return offImage ?? onImage
        } else {
            return onImage
        }
    }
}

struct StarRatingPickerView_Previews: PreviewProvider {
    static var previews: some View {
        StarRatingPickerView(rating: .constant(4))
    }
}
