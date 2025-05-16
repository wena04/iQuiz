//
//  QuizSummaryScreen.swift
//  iQuiz
//
//  Created by Anthony Wen on 5/14/25.
//

import SwiftUI

struct QuizSummaryScreen: View {
    let correctAnswers: Int
    let category: Category
    @Environment(\.dismiss) private var dismiss

    var resultMessage: String {
        let total = category.questions.count

        switch correctAnswers {
        case total:
            return "Perfect!"
        case total - 1:
            return "Almost there!"
        case 0:
            return "You should study more."
        default:
            return "Keep practicing!"
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                Text("Correct Answers: \(correctAnswers)/\(category.questions.count)")
                    .font(.title)
                    .fontWeight(.semibold)

                Text(resultMessage)
                    .font(.headline)

                NavigationLink(destination: ContentView()) {
                    Text("Back to Home")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.orange)
                        .cornerRadius(10)
                }

                Text("💡 Tip: Swipe left to return to home.")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 40)
            .navigationTitle("Quiz Summary")
            .highPriorityGesture(
                DragGesture().onEnded { value in
                    if value.translation.width < -50 {
                        print("⬅️ Swipe Left: Returning to home")
                        dismiss()
                    }
                }
            )
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    QuizSummaryScreen(
        correctAnswers: 2,
        category: Category(
            title: "Math",
            desc: "Simple math quiz",
            questions: [
                Question(text: "What is 1 + 1?", answer: "0", answers: ["2", "3", "4"]),
                Question(text: "What is 2 * 2?", answer: "0", answers: ["4", "2", "6"]),
                Question(text: "What is 9 / 3?", answer: "0", answers: ["3", "6", "1"])
            ]
        )
    )
}
