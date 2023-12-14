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
    
    @State private var comment: String = ""
    @State private var commentWordCount = 0
    @State var photo: Data?
    @State private var photosPickerItem: PhotosPickerItem?
    @State private var showErrorMessage = false
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
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
                            
                            Text("Share the pros, cons, and what to expect when living at \(selectedDorm) (at least 20 words)")
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
                                .onChange(of: comment) { newComment in
                                    countWords()
                                    if (commentWordCount < 20) {
                                        showErrorMessage = true
                                    } else {
                                        showErrorMessage = false
                                    }
                                }
                            
                            if (showErrorMessage) {
                                Text("Comment must be at least 20 words")
                                    .font(.subheadline)
                                    .foregroundColor(.red)
                            }
                        }
                        
                        Group {
                            Text("Upload Photo")
                                .font(.title)
                                .bold()
                                .padding(.bottom, 1)
                                .padding(.top)
                            
                            Text("Show us what your dorm was like! (Optional)")
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
                                    .padding(.top, 10)
                            }
                        }
                        
                        Spacer()
                    }
                    .padding()
                    .padding(.horizontal, 10)
                    .frame(minHeight: geometry.size.height)
                    .onChange(of: photosPickerItem) { _ in
                        Task {
                            if let data = try? await photosPickerItem?.loadTransferable(type: Data.self) {
                                photo = data
                            }
                        }
                    }
                }
                .frame(width: geometry.size.width)
                
                // bottom buttons
                VStack {
                    Spacer()
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
                        if (commentWordCount >= 20) {
                            NavigationLink(
                                destination: AddRatingFourthView(selectedDorm: $selectedDorm, roomRating: $roomRating, buildingRating: $buildingRating, bathroomRating: $bathroomRating, locationRating: $locationRating, comment: $comment, photo: $photo),
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
                .padding()
                .padding(.horizontal, 10)
                .frame(minHeight: geometry.size.height)
            }
        }
        .navigationBarHidden(true)
    }
    
    func countWords() {
        // Split the comment into words and count them
        let words = comment.split { $0.isWhitespace || $0.isNewline }
        commentWordCount = words.count
    }
}

struct AddRatingThirdView_Previews: PreviewProvider {
    static var previews: some View {
        AddRatingThirdView(selectedDorm: .constant("Dorm 1"), roomRating: .constant(4), buildingRating: .constant(4), bathroomRating: .constant(3), locationRating: .constant(5) )
    }
}
