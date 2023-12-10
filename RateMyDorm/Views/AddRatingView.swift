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
            VStack {
                ZStack {
                    
                }
                
                // main content
                ScrollView {
                    
                }
                
                Spacer()
                
                // back button
                HStack {
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
