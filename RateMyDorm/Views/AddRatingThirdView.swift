//
//  AddRatingThirdView.swift
//  RateMyDorm
//
//  Created by Manling Zhao on 12/11/23.
//

import SwiftUI
import PhotosUI

struct AddRatingThirdView: View {
    @Binding var selectedDorm: String
    @Binding var roomRating: Int
    @Binding var buildingRating: Int
    @Binding var bathroomRating: Int
    @Binding var locationRating: Int
    
    @State private var showFourthView = false
    @State private var comment: String = ""
    @State var photo: Data?
    @State private var photosPickerItem: PhotosPickerItem?
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    ProgressView(value: 0.5)
                        .tint(.teal)
                    
                    Text("Step 2: Additionals")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.top, 5)
                    
                    Group {
                        Text("Write a comment")
                            .font(.title)
                            .bold()
                            .padding(.bottom, 1)
                            .padding(.top, 5)
                        
                        Text("Share the pros, cons, and what to expect when living at \(selectedDorm)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        TextEditor(text: $comment)
                            .frame(height: 150)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.gray.opacity(0.2), lineWidth: 2)
                            )
                    }
                    
                    Group {
                        Text("Upload Photo")
                            .font(.title)
                            .bold()
                            .padding(.bottom, 1)
                            .padding(.top, 5)
                        
                        Text("Share the pros, cons, and what to expect when living at \(selectedDorm)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            
                        
                        PhotosPicker(selection: $photosPickerItem, matching: .images) {
                            Text("Choose Image")
                        }
                        .padding(.top, 1)
                        
                        if let photo, let uiImage = UIImage(data: photo) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 200, height: 120)
                                .padding(.top, 10)
                        } else {
                            Image("")
                                .frame(width: 200, height: 120)
                        }
                    }
                    
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
                        
                        // next page
                        Button(action: {
                                showFourthView = true
                        }, label: {
                            Image(systemName: "arrow.right")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                                .frame(width: 50, height: 50)
                                .background(.teal)
                                .cornerRadius(30)
                        })
                    }
                    .padding(.top, 112)
                }
                .padding()
                .padding(.leading, 10)
                .padding(.trailing, 10)
                .onChange(of: photosPickerItem) { _ in
                    Task {
                        if let data = try? await photosPickerItem?.loadTransferable(type: Data.self) {
                            photo = data
                        }
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct AddRatingThirdView_Previews: PreviewProvider {
    static var previews: some View {
        AddRatingThirdView(selectedDorm: .constant("Dorm 1"), roomRating: .constant(4), buildingRating: .constant(4), bathroomRating: .constant(3), locationRating: .constant(5) )
    }
}
