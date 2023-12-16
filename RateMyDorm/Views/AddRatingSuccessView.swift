//
//  AddRatingSuccessView.swift
//  RateMyDorm
//
//  Created by Manling Zhao on 12/12/23.
//

import SwiftUI

struct AddRatingSuccessView: View {
    
    @State private var opacity1: Double = 0
    @State private var opacity2: Double = 0
    @State private var opacity3: Double = 0
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var userViewModel: UserViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Congrats!🎉")
                    .font(.system(size: 36))
                    .bold()
                    .padding(.bottom, 5)
                    .opacity(opacity1)
                    .onAppear {
                        withAnimation(Animation.easeInOut(duration: 1.5).delay(0)) {
                            opacity1 = 1
                        }
                    }
                
                Text("Your review has been submitted")
                    .font(.system(size: 20))
                    .padding(.bottom, 15)
                    .opacity(opacity2)
                    .onAppear {
                        withAnimation(Animation.easeInOut(duration: 1.5).delay(1)) {
                            opacity2 = 1
                        }
                    }

                // back to home page
                NavigationLink(
                    destination: HomeNavView(),
                    label: {
                        Text("Back to home")
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 55)
                            .background(.teal)
                            .cornerRadius(20)
                    }
                )
                .padding(.horizontal, 20)
                .opacity(opacity3)
                .onAppear {
                    withAnimation(Animation.easeInOut(duration: 1.5).delay(2)) {
                        opacity3 = 1
                    }
                }
            }
            .padding()
        }
        .navigationBarHidden(true)
    }
}

struct AddRatingSuccessView_Previews: PreviewProvider {
    static var previews: some View {
        AddRatingSuccessView()
    }
}
