//
//  QuizScreen.swift
//  iQuiz
//
//  Created by Anthony Wen on 5/14/25.
//

import SwiftUI

struct QuizScreen: View {
    
    let category: Category
    let currentQuestionIndex: Int
    let correctAnswers: Int
    @State private var selectedAnswerIndex: Int = -1
    @State private var showAnswer = false
    @Environment(\.dismiss) private var dismiss

    init(category: Category, currentQuestionIndex: Int, correctAnswers: Int) {
        self.category = category
        self.currentQuestionIndex = currentQuestionIndex
        self.correctAnswers = correctAnswers
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text(category.questions[currentQuestionIndex].text)
                    .font(.title)
                
                ForEach(0..<category.questions[currentQuestionIndex].answers.count, id: \.self) { index in
                    Button(action: {
                        selectedAnswerIndex = index
                    }) {
                        Text(category.questions[currentQuestionIndex].answers[index])
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(selectedAnswerIndex == index ? Color.blue : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(40)
                            .font(.system(size: 27))
                    }
                    .padding(.horizontal, 40)
                }
                
                Button("Submit") {
                    if selectedAnswerIndex != -1 {
                        showAnswer = true
                    }
                }
                .disabled(selectedAnswerIndex == -1)

                Text("💡 Tip: Swipe right to submit, left to quit.")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.top, 10)
            }
            .padding()
            .background(Color.green.opacity(0.2)) // light green background
            .border(Color.blue, width: 1) // add border to swipe zone
            .highPriorityGesture(
                DragGesture().onEnded { value in
                    print("Swipe detected: \(value.translation.width)")
                    if value.translation.width > 50 && selectedAnswerIndex != -1 {
                        print("➡️ Swipe Right Detected")
                        showAnswer = true
                    } else if value.translation.width < -50 {
                        print("⬅️ Swipe Left Detected")
                        dismiss()
                    }
                }
            )
            .navigationDestination(isPresented: $showAnswer) {
                AnswerCheckScreen(
                    question: category.questions[currentQuestionIndex],
                    selectedAnswerIndex: selectedAnswerIndex,
                    currentQuestionIndex: currentQuestionIndex,
                    category: category,
                    correctAnswers: correctAnswers
                )
            }
            .navigationBarTitle("Question \(currentQuestionIndex + 1)")
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    QuizScreen(
        category:
            Category(
                title: "Mathematics",
                desc: "Take a simple math quiz.",
                questions: [
                    Question(text: "What is 10 + 7?", answer: "1", answers: ["17", "20", "3", "15"]),
                    Question(text: "What is 5 * 3?", answer: "4", answers: ["179", "10", "2321", "15"]),
                    Question(text: "What is the value of pi rounded?", answer: "2", answers: ["3.18", "3.14", "3.20", "3.15"])
                ]),
        currentQuestionIndex: 0,
        correctAnswers: 0
    )
}
