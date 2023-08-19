//
//  ContentView.swift
//  LearningApp
//
//  Created by Rakhyun Kim on 8/19/23.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        
        @EnvironmentObject var model: ContentModel
        
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
