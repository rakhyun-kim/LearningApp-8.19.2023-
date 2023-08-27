//
//  TestView.swift
//  LearningApp
//
//  Created by Rakhyun Kim on 8/25/23.
//

import SwiftUI

struct TestView: View {
    
    @EnvironmentObject var model: ContentModel
    
    var body: some View {
        
        if model.currentQuestion != nil {
            
            VStack {
                
                // Question number
                Text("Question \(model.currentQuestionIndex + 1 ) of \(model.currentModule?.test.questions.count ?? 0)")
                
                // Question
                CodeTextView()
                
                // Answers
                
                // Button
                
            }
            .navigationTitle("\(model.currentModule?.category ?? "") Test")
        }
        else {
            // Test has't loaded yet
            ProgressView()
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
