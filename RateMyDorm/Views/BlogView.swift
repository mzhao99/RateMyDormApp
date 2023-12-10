//
//  BlogView.swift
//  RateMyDorm
//
//  Created by Manling Zhao on 12/9/23.
//

import SwiftUI

struct BlogView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Second Screen")
            }
            .navigationTitle("Blog")
        }
    }
}


struct SecondTabView: View {
    var body: some View {
        Text("Second Tab View")
    }
}

struct DetailView: View {
    var body: some View {
        Text("Detail")
    }
}


struct BlogView_Previews: PreviewProvider {
    static var previews: some View {
        BlogView()
    }
}
