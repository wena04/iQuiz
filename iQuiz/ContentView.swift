import SwiftUI

struct ContentView: View {
    @State private var categories: [Category] = []
    @AppStorage("quizURL") private var quizURL: String = "http://tednewardsandbox.site44.com/questions.json"
    @AppStorage("refreshInterval") private var refreshInterval: Int = 30
    @State private var timer: Timer?
    @State private var loadSource: String? = nil

    private var defaultCategories: [Category] = [
        Category(title: "Mathematics", desc: "Take a simple math quiz.", questions: [
            Question(text: "What is 10 + 7?", answer: "1", answers: ["17", "20", "3", "15"]),
            Question(text: "What is 5 * 3?", answer: "4", answers: ["179", "10", "2321", "15"]),
            Question(text: "What is the value of pi rounded?", answer: "2", answers: ["3.18", "3.14", "3.20", "3.15"])
        ]),
        Category(title: "Science", desc: "Test your science knowledge.", questions: [
            Question(text: "What is the chemical symbol for water?", answer: "2", answers: ["Wa", "H2O", "Wa", "O2"])
        ]),
        Category(title: "Marvel SuperHeroes", desc: "How well do you know the MU?", questions: [
            Question(text: "What is the name of the metal alloy used to create Captain America's shield?", answer: "2", answers: ["Adamantium", "Vibranium", "Promethium", "Titanium"])
        ])
    ]

    var body: some View {
        NavigationStack {
            VStack {
                Text("💡 Tip: Pull down to refresh quiz list")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.top, 5)
                
                if let loadSource {
                                Text(loadSource)
                                    .font(.caption)
                                    .foregroundColor(.blue)
                                    .padding(.bottom, 5)
                            }

                List(
                    categories.isEmpty ? defaultCategories : categories,
                    id: \.self
                ) { category in
                    NavigationLink(destination:
                        QuizScreen(category: category, currentQuestionIndex: 0, correctAnswers: 0)) {
                        HStack {
                            Image(systemName: "questionmark.bubble.fill")
                                .font(.system(size: 30))
                                .padding(.trailing, 10)
                                .foregroundStyle(Color(.green))
                            VStack(alignment: .leading, spacing: 10) {
                                Text(category.title).font(.system(size: 20))
                                Text(category.desc).foregroundStyle(.gray)
                            }
                        }
                    }
                }
                .refreshable {
                    await downloadData()
                }
            }
            .navigationTitle("Home")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: Settings(categories: $categories)) {
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: 25))
                            .padding(10)
                    }
                }
            }
            .onAppear {
                startTimer()
            }
            .onDisappear {
                stopTimer()
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    // MARK: - Unified Download Function
    @MainActor
    func downloadData() async {
        guard let url = URL(string: quizURL) else {
            print("❌ Invalid or missing URL")
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode([Category].self, from: data)
            categories = decoded
            saveToFile(data)
            loadSource = "✅ Loaded from network"
            print("✅ Loaded from network")
        } catch {
            print("❌ Network failed, loading from local file: \(error)")
            await MainActor.run {
                        loadSource = "📂 Loaded from local file"
                    }
            loadFromFile()
        }
    }

    // MARK: - Timer for Auto Refresh
    func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(refreshInterval), repeats: true) { _ in
            Task {
                await downloadData()
            }
        }
        print("⏰ Started timer with interval \(refreshInterval) sec")
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
        print("🛑 Stopped timer")
    }

    // MARK: - File I/O
    func saveToFile(_ data: Data) {
        let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("quizzes.json")
        do {
            try data.write(to: fileURL)
            print("✅ Saved to local file: \(fileURL)")
        } catch {
            print("❌ Failed to save: \(error)")
        }
    }

    func loadFromFile() {
        let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("quizzes.json")
        do {
            let data = try Data(contentsOf: fileURL)
            let decoded = try JSONDecoder().decode([Category].self, from: data)
            categories = decoded
            print("📂 Loaded from local file")
        } catch {
            print("❌ Failed to load local quizzes: \(error)")
            loadSource = "❌ Failed to load local data"
        }
    }
}
