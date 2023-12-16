//
//  OverallRatingComponentView.swift
//  RateMyDorm
//
//  Created by Manling Zhao on 12/15/23.
//

import SwiftUI

struct OverallRatingComponentView: View {
    @Binding var overallRating: Double
    
    var body: some View {
        VStack {
            Text("Overall")
                .bold()
            Text(String(format: "%.1f", overallRating))
                .bold()
                .font(.system(size: 20.0, weight: .heavy))
        }
        .padding(.vertical)
        .padding(.horizontal,12)
        .background(colorForRating(overallRating))
        .cornerRadius(15)
    }
}

private func colorForRating(_ rating: Double) -> Color {
    if rating >= 4.0 {
        return Color.green
    } else if rating >= 3.0 {
        return Color.yellow
    } else {
        return Color.red
    }
}

struct OverallRatingComponentView_Previews: PreviewProvider {
    static var previews: some View {
        OverallRatingComponentView(overallRating: .constant(3.5))
    }
}
