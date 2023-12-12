//
//  AddRatingFinalView.swift
//  RateMyDorm
//
//  Created by Manling Zhao on 12/12/23.
//

import SwiftUI

struct AddRatingFinalView: View {
    @Binding var selectedDorm: String
    @Binding var roomRating: Int
    @Binding var buildingRating: Int
    @Binding var bathroomRating: Int
    @Binding var locationRating: Int
    @Binding var comment: String
    @Binding var photo: Data?
    @Binding var selectedClassYears: Array<Bool>
    @Binding var selectedRoomTypes: Array<Bool>
    
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        NavigationView {
            
            VStack {
                // bottom buttons
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
                }
            }
            // V Stack padding
            .padding()
            .padding(.leading, 10)
            .padding(.trailing, 10)
        }
        .navigationBarHidden(true)
    }
}

struct AddRatingFinalView_Previews: PreviewProvider {
    static var previews: some View {
        AddRatingFinalView(selectedDorm: .constant("Dorm 1"), roomRating: .constant(4), buildingRating: .constant(4), bathroomRating: .constant(3), locationRating: .constant(5), comment: .constant("This is a comment"), photo: .constant(UIImage(systemName: "photo")?.jpegData(compressionQuality: 1.0)), selectedClassYears: .constant([true, true, false, false, false]), selectedRoomTypes: .constant([true, false, false, true, false, false]))
    }
}
