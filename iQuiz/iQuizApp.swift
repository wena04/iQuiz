//
//  iQuizApp.swift
//  iQuiz
//
//  Created by stlp on 5/7/24.
//

import SwiftUI

@main
struct iQuizApp: App {
    init() {
            UserDefaults.standard.register(defaults: [
                "quizURL": "https://tednewardsandbox.site44.com/questions.json",
                "refreshInterval": 30
            ])
        }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
