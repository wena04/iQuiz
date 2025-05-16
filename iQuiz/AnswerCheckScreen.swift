//
//  AnswerCheckScreen.swift
//  iQuiz
//
//  Created by Anthony Wen on 5/14/25.
//

import SwiftUI

struct AnswerCheckScreen: View {
    let question: Question
    let selectedAnswerIndex: Int?
    let currentQuestionIndex: Int
    let category: Category
    let correctAnswers: Int

    @State private var goToNext = false
    @Environment(\.dismiss) private var dismiss

    var isCorrect: Bool {
        guard let selected = selectedAnswerIndex else { return false }
        return selected + 1 == Int(question.answer)
    }

    var updatedScore: Int {
        isCorrect ? correctAnswers + 1 : correctAnswers
    }

    var body: some View {
        NavigationStack {
            ZStack {
                // 👇 Background area to show swipe zone
                Color.blue.opacity(0.05) // light tint for visual
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    Text(question.text)
                        .font(.title)
                        .fontWeight(.bold)

                    if selectedAnswerIndex == nil {
                        Text("No answer selected")
                            .foregroundColor(.gray)
                            .font(.headline)
                    } else if isCorrect {
                        Text("✅ Correct!")
                            .foregroundColor(.green)
                            .font(.headline)
                    } else {
                        Text("❌ Wrong!")
                            .foregroundColor(.red)
                            .font(.headline)
                    }

                    Button(currentQuestionIndex < category.questions.count - 1 ? "Next" : "Finish") {
                        goToNext = true
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)

                    Text("💡 Tip: Swipe ➡️ to continue, ⬅️ to quit")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.top, 10)
                }
                .padding()
            }
            .navigationTitle("Question \(currentQuestionIndex + 1)")
            .navigationDestination(isPresented: $goToNext) {
                if currentQuestionIndex < category.questions.count - 1 {
                    QuizScreen(
                        category: category,
                        currentQuestionIndex: currentQuestionIndex + 1,
                        correctAnswers: updatedScore
                    )
                } else {
                    QuizSummaryScreen(
                        correctAnswers: updatedScore,
                        category: category
                    )
                }
            }
            .highPriorityGesture(
                DragGesture().onEnded { value in
                    print("Swipe detected: \(value.translation.width)")
                    if value.translation.width > 50 {
                        goToNext = true
                    } else if value.translation.width < -50 {
                        dismiss()
                    }
                }
            )
        }
        .navigationBarBackButtonHidden(true)
    }
}
