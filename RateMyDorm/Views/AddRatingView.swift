//
//  AddReviewView.swift
//  RateMyDorm
//
//  Created by Manling Zhao on 12/9/23.
//

import SwiftUI

struct AddRatingView: View {
    @Binding var showAddRating: Bool
        
    var body: some View {
        Spacer().fullScreenCover(isPresented: $showAddRating, content: {
                    Button(action: {
                        showAddRating.toggle()
                    }, label: {
                        Text("Close")
                    })
        })
    }
}

//struct AddRatingView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddRatingView(showAddRating: show)
//    }
//}
