//
//  AddRatingThirdView.swift
//  RateMyDorm
//
//  Created by Manling Zhao on 12/11/23.
//

import SwiftUI

struct AddRatingThirdView: View {
    @Binding var showThirdView: Bool
    @Binding var selectedDorm: String
    @Binding var roomRating: Int
    @Binding var buildingRating: Int
    @Binding var bathroomRating: Int
    @Binding var locationRating: Int
    
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct AddRatingThirdView_Previews: PreviewProvider {
    static var previews: some View {
        AddRatingThirdView(showThirdView: .constant(true), selectedDorm: .constant("Dorm 1"), roomRating: .constant(4), buildingRating: .constant(4), bathroomRating: .constant(3), locationRating: .constant(5) )
    }
}
