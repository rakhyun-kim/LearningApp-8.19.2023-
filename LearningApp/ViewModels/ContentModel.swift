//
//  ContentModel.swift
//  LearningApp
//
//  Created by Rakhyun Kim on 8/19/23.
//

import Foundation

class ContentModel: ObservableObject {
    
    // List of modules
    @Published var modules = [Module]()
    
    // Current module
    @Published var currentModule: Module?
    var currentModuleIndex = 0
    
    // Current Lesson
    @Published var currentLesson: Lesson?
    var currentLessonIndex = 0
    
    // Current question
    @Published var currentQuestion: Questions?
    var currentQuestionIndex = 0
    
    // Current lesson explanation
    @Published var codeText = NSAttributedString()
    var styleData: Data?
    
    // Current selected content and test
    @Published var currentContentSelected:Int?
    @Published var currentTestSelected:Int?
    
    init() {
        
        // Parse local included json data
        getLocalData()
        
        // Download remote json file and parse data
        getRemoteData()
    }
    
    // MARK: - Data Methods
    func getLocalData() {
        
        let jsonUrl = Bundle.main.url(forResource: "data", withExtension: "json")
        
        do {
            
            let jsonData = try Data(contentsOf: jsonUrl!)
            
            let decoder = JSONDecoder()
            
            let modules = try decoder.decode([Module].self, from: jsonData)
            
            // Assign parsed modules to modules property
            self.modules =  modules
            
            
        }
        catch {
            print("Couldn`t parse local data")
        }
        
        // Parse the style data
        let styleUrl = Bundle.main.url(forResource: "style", withExtension: "html")
        
        do {
            // Read the file into a data object
            let styleData = try Data(contentsOf: styleUrl!)
            
            self.styleData = styleData
            
        }
        catch {
            print("Couldn`t parse style data")
        }
    }
    
    func getRemoteData() {
        
        // String path
        let urlString = "https://rakhyun-kim.github.io/LearningApp-Data/data2.json"
        
        // Create a url object
        let url = URL(string: urlString)
        
        guard url != nil else {
            // Couldn`t create url
            return
        }
        
        // Create a URL Request Object
        let request = URLRequest(url: url!)
        
        // Get the session and kick off the task
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: request) { data, response, error in
            
            // Check if there is an error
            guard error == nil else {
                // There was an error
                return
            }
            
            do {
                // Create json decoder
                
                let decoder = JSONDecoder()
                
                //decode
                
                let modules = try decoder.decode([Module].self, from: data!)
                
                DispatchQueue.main.sync {
                   
                    // Append parsed modules into modules property
                    self.modules += modules
                    
                }
                
            }
            catch {
                // Couldn`t parse json
            }
            
        }
        
        // Kick off data task
        dataTask.resume()
        
    }
    
    // MARK: - Module navigtaion methods
    
    func beginModule(_ moduleid:Int) {
        
        // Find the index for this module id
        for index in 0..<modules.count {
            if modules[index].id == moduleid {
                
                // Found the matching module
                currentModuleIndex = index
                break
            }
            
        }
        
        // Set the current module
        currentModule = modules[currentModuleIndex]
    }
    
    func beginLesson(_ lessonIndex:Int) {
        
        // Check that the lesson index is within range of module lessons
        if lessonIndex < currentModule!.content.lessons.count {
            currentLessonIndex = lessonIndex
        }
        else {
            currentLessonIndex = 0
        }
        // Set the current lesson
        currentLesson = currentModule!.content.lessons[currentLessonIndex]
        codeText = addStyling(currentLesson!.explanation)
    }
    func nextLesson() {
        
        // Advance the lesson
        currentLessonIndex += 1
        
        // Check that it is wihin range
        if currentLessonIndex < currentModule!.content.lessons.count {
            
            // Set the current lesson property
            currentLesson = currentModule!.content.lessons[currentLessonIndex]
             codeText = addStyling(currentLesson!.explanation)
        }
        else {
            // Reset the lesson state
            currentLessonIndex = 0
            currentLesson = nil
        }
        
        
    }
    
    func hasNextLesson() -> Bool {
        
        guard currentModule != nil else {
            return false
        }
        
        return (currentLessonIndex + 1 < currentModule!.content.lessons.count)
//        if currentLessonIndex + 1 < currentModule!.content.lessons.count {
//            return true
//        }
//        else {
//            return false
//        }
    }
    func beginTest(_ moduleId:Int) {
        
        // Set the current module
        beginModule(moduleId)
        
        // Set the current question
        currentQuestionIndex = 0
        
        // If there are question, set the current question to the first one
        if currentModule?.test.questions.count ?? 0 > 0 {
            currentQuestion = currentModule!.test.questions[currentQuestionIndex]
            codeText = addStyling(currentQuestion!.content)
        }
    }
    
    func nextQuestion() {
         
        // Advance the question index
        currentQuestionIndex += 1
        
        // Check that it's whithin the range of questions
        if currentQuestionIndex < currentModule!.test.questions.count {
            
            // Set the current question
            currentQuestion = currentModule!.test.questions[currentQuestionIndex]
            codeText = addStyling(currentQuestion!.content)
        }
        else {
            currentQuestionIndex = 0
            currentQuestion = nil
        }
    }
    
    // MARK: - code styling
    
    private func addStyling(_ htmlString: String) -> NSAttributedString {
        
        var resultString = NSAttributedString()
        var data = Data()
        
        // Add the styling data
        if styleData != nil {
            data.append(styleData!)
        }
        
        // Add the html data
        data.append(Data(htmlString.utf8))
        
        // Convert to attributed string
        
            if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
                
                resultString = attributedString
            }
        return resultString
    }
}
