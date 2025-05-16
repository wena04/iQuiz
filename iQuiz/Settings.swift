//
//  Settings.swift
//  iQuiz
//
//  Created by Anthony Wen on 5/14/25.
//

import SwiftUI

struct Settings: View {
    @AppStorage("quizURL") private var jsonURL: String = "http://tednewardsandbox.site44.com/questions.json"
    @AppStorage("refreshInterval") private var refreshInterval: Int = 60

    @State private var showUrlAlert = false
    @State private var showNetworkErrorAlert = false
    @Binding var categories: [Category]

    var body: some View {
        VStack(spacing: 30) {
            Text("Enter URL to quiz data")
                .frame(maxWidth: .infinity, alignment: .leading)

            TextField("Enter URL here", text: $jsonURL)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button("Check Now") {
                downloadData()
            }
            .frame(maxWidth: .infinity)
            .padding()
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(10)
            .alert("Invalid URL", isPresented: $showUrlAlert) {
                Button("OK", role: .cancel) { }
            }

            Divider()

            VStack(alignment: .leading, spacing: 10) {
                Text("Auto-refresh interval: \(refreshInterval) seconds")
                    .font(.subheadline)

                Stepper("Set refresh interval", value: $refreshInterval, in: 10...600, step: 10)
            }

        }
        .padding(40)
        .navigationTitle("Settings")
        .alert("Network Error", isPresented: $showNetworkErrorAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Please check your internet connection and try again.")
        }
    }

    private func downloadData() {
        guard let url = URL(string: jsonURL) else {
            showUrlAlert = true
            return
        }

        print("🔄 Fetching data from: \(url)")

        let session = URLSession.shared
        let task = session.dataTask(with: url) { data, response, error in

            if let error = error {
                print("❌ Error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.showNetworkErrorAlert = true
                }
                return
            }

            guard let data = data else {
                print("❌ No data received")
                return
            }

            do {
                let decoder = JSONDecoder()
                let downloadedCategories = try decoder.decode([Category].self, from: data)
                print("✅ Successfully read \(downloadedCategories.count) categories")

                DispatchQueue.main.async {
                    self.categories = downloadedCategories
                }

            } catch {
                print("❌ Error decoding JSON: \(error.localizedDescription)")
            }
        }

        task.resume()
    }
}
