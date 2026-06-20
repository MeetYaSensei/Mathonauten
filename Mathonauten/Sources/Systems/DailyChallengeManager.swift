import Foundation

struct DailyChallenge {
    let multiplier: Int
    let factor: Int
    let gemReward: Int
    var isCompleted: Bool
}

final class DailyChallengeManager {

    static let shared = DailyChallengeManager()
    private let defaults = UserDefaults.standard
    private init() {}

    private(set) var challenges: [DailyChallenge] = []

    var allCompleted: Bool {
        !challenges.isEmpty && challenges.allSatisfy { $0.isCompleted }
    }

    // MARK: - Public API

    func refreshIfNeeded() {
        let today = todayString()
        if defaults.string(forKey: "dc_date") == today,
           let qData = defaults.data(forKey: "dc_questions"),
           let questions = try? JSONDecoder().decode([[Int]].self, from: qData) {
            let cData = defaults.data(forKey: "dc_completed") ?? Data()
            let completed = (try? JSONDecoder().decode([Bool].self, from: cData)) ?? [false, false, false]
            challenges = build(questions: questions, completed: completed)
        } else {
            let seed = dateSeed()
            let questions = generate(seed: seed)
            challenges = build(questions: questions, completed: [false, false, false])
            defaults.set(today, forKey: "dc_date")
            if let data = try? JSONEncoder().encode(questions) {
                defaults.set(data, forKey: "dc_questions")
            }
            saveCompleted()
        }
    }

    func markCompleted(index: Int) {
        guard index < challenges.count, !challenges[index].isCompleted else { return }
        challenges[index].isCompleted = true
        ProgressManager.shared.addGems(challenges[index].gemReward)
        saveCompleted()
    }

    // MARK: - Private

    private func todayString() -> String {
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd"
        return fmt.string(from: Date())
    }

    private func dateSeed() -> Int {
        let c = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        return (c.year! * 10000) + (c.month! * 100) + c.day!
    }

    private func seededInt(seed: Int, max: Int) -> Int {
        var s = UInt64(bitPattern: Int64(seed))
        s ^= s << 13; s ^= s >> 7; s ^= s << 17
        return Int(s % UInt64(max))
    }

    private func generate(seed: Int) -> [[Int]] {
        let easy:   [Int] = [2, 3]
        let medium: [Int] = [4, 5]
        let hard:   [Int] = [6, 7, 8, 9]

        let eM = easy[seededInt(seed: seed + 0, max: easy.count)]
        let eF = seededInt(seed: seed + 1, max: 9) + 2
        let mM = medium[seededInt(seed: seed + 2, max: medium.count)]
        let mF = seededInt(seed: seed + 3, max: 9) + 2
        let hM = hard[seededInt(seed: seed + 4, max: hard.count)]
        let hF = seededInt(seed: seed + 5, max: 9) + 2

        return [[eM, eF], [mM, mF], [hM, hF]]
    }

    private func build(questions: [[Int]], completed: [Bool]) -> [DailyChallenge] {
        let rewards = [5, 10, 20]
        return questions.enumerated().map { i, q in
            DailyChallenge(
                multiplier: q[0], factor: q[1],
                gemReward: rewards[i],
                isCompleted: i < completed.count ? completed[i] : false
            )
        }
    }

    private func saveCompleted() {
        if let data = try? JSONEncoder().encode(challenges.map { $0.isCompleted }) {
            defaults.set(data, forKey: "dc_completed")
        }
    }
}
