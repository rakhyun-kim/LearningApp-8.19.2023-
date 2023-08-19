//
//  LearningAppApp.swift
//  LearningApp
//
//  Created by Rakhyun Kim on 8/19/23.
//

import SwiftUI

@main
struct LearningApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(ContentModel())
        }
    }
}
