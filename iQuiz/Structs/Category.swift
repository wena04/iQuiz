//
//  Category.swift
//  iQuiz
//
//  Created by Anthony  Wen on 5/14/25.
//

struct Category: Codable, Hashable {
    let title: String
    let desc: String
//    let icon: String
    let questions: [Question]
}
