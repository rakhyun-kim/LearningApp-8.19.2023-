//
//  TestResultView.swift
//  LearningApp
//
//  Created by Rakhyun Kim on 8/31/23.
//

import SwiftUI

struct TestResultView: View {
    
    @EnvironmentObject var model: ContentModel
    
    var numCorrect = 0
    
    var resultHeading: String {
        
        guard model.currentModule != nil else {
            return ""
        }
        
        let pct =  Double(numCorrect)/Double(model.currentModule!.test.questions.count)
        
        if pct > 0.5 {
            return "Awesome"
        }
        else if pct > 0.2 {
            return "Doing great!"
        }
        else {
            return "Keep learning"
        }
        
    }
    
    var body: some View {
        
        VStack {
            
            Spacer()
            
            Text(resultHeading)
                .font(.title)
            
            Spacer()
            
            Text("You got \(numCorrect) out of \(model.currentModule?.test.questions.count ?? 0) questions")
            
            Button {
                
                // Send the user back to the home view
                model.currentTestSelected = nil
                
            } label: {
                
                ZStack {
                    RectangleCard(color: .green)
                        .frame(height: 48)
                    
                    Text("Complete")
                        .bold()
                        .foregroundColor(.white)
                }
                .padding()
                
                Spacer()
            }

        }
    }
}
