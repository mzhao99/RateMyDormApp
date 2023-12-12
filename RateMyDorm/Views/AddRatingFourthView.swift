//
//  AddRatingFourthView.swift
//  RateMyDorm
//
//  Created by Manling Zhao on 12/12/23.
//

import SwiftUI

struct AddRatingFourthView: View {
    @Binding var selectedDorm: String
    @Binding var roomRating: Int
    @Binding var buildingRating: Int
    @Binding var bathroomRating: Int
    @Binding var locationRating: Int
    @Binding var comment: String
    @Binding var photo: Data?
    
    @State private var showFinalView = false
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    ProgressView(value: 0.75)
                        .tint(.teal)
                    
                    
                    HStack {
                        // previous page
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Image(systemName: "arrow.left")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                                .frame(width: 50, height: 50)
                                .background(.teal)
                                .cornerRadius(30)
                        })
                        
                        Spacer()
                        
                        // next page
                        NavigationLink(
                            destination: AddRatingFinalView(),
                            isActive: $showFinalView,
                            label: {
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 20))
                                    .foregroundColor(.white)
                                    .frame(width: 50, height: 50)
                                    .background(.teal)
                                    .cornerRadius(30)
                            }
                        )
                    }
                }
            }
            
        }
    }
}

struct AddRatingFourthView_Previews: PreviewProvider {
    static var previews: some View {
        AddRatingFourthView(selectedDorm: .constant("Dorm 1"), roomRating: .constant(4), buildingRating: .constant(4), bathroomRating: .constant(3), locationRating: .constant(5), comment: .constant("This is a comment"), photo: .constant(UIImage(systemName: "photo")?.jpegData(compressionQuality: 1.0)))
    }
}
