import SwiftUI

struct Settings: View {
    @AppStorage("quizURL") private var storedURL: String = "http://tednewardsandbox.site44.com/questions.json"
    @AppStorage("refreshInterval") private var refreshInterval: Int = 60

    @Binding var categories: [Category]

    @State private var urlText: String = ""
    @State private var showUrlAlert = false
    @State private var showNetworkErrorAlert = false
    @State private var loadStatus: String? = nil

    var body: some View {
        VStack(spacing: 30) {
            Text("Enter URL to quiz data")
                .frame(maxWidth: .infinity, alignment: .leading)

            TextField("Enter URL here", text: $urlText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onAppear {
                    urlText = storedURL
                }

            Button("Check Now") {
                guard !urlText.isEmpty else {
                    showUrlAlert = true
                    return
                }
                storedURL = urlText
                downloadData(from: storedURL)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(10)

            // ✅ Status Message
            if let status = loadStatus {
                Text(status)
                    .font(.caption)
                    .foregroundColor(.blue)
                    .transition(.opacity)
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
        .alert("Invalid URL", isPresented: $showUrlAlert) {
            Button("OK", role: .cancel) { }
        }
        .alert("Network Error", isPresented: $showNetworkErrorAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Please check your internet connection and try again.")
        }
    }

    private func downloadData(from urlString: String) {
        guard let url = URL(string: urlString) else {
            showUrlAlert = true
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("❌ Error: \(error)")
                DispatchQueue.main.async {
                    showNetworkErrorAlert = true
                    loadStatus = "❌ Failed to load from network"
                }
                return
            }

            guard let data = data else {
                print("❌ No data received")
                return
            }

            do {
                let decoded = try JSONDecoder().decode([Category].self, from: data)
                DispatchQueue.main.async {
                    categories = decoded
                    loadStatus = "✅ Loaded from network"
                }
            } catch {
                print("❌ JSON decode failed: \(error)")
                DispatchQueue.main.async {
                    loadStatus = "❌ Failed to decode data"
                }
            }
        }.resume()
    }
}
