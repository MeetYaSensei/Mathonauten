import Foundation

struct MathQuestion {
    let a: Int
    let b: Int
    let correctAnswer: Int
    let wrongAnswers: [Int]

    var allAnswers: [Int] {
        [correctAnswer] + wrongAnswers
    }

    /// Generiert eine Aufgabe aus der Malfolge
    static func generate(table: Int, maxFactor: Int = 10) -> MathQuestion {
        let a = table
        let b = Int.random(in: 1...maxFactor)
        let correct = a * b

        var wrongs = Set<Int>()
        while wrongs.count < 3 {
            let offset = Int.random(in: -3...3)
            let candidate = correct + offset * a
            if candidate != correct && candidate > 0 {
                wrongs.insert(candidate)
            }
        }
        return MathQuestion(a: a, b: b, correctAnswer: correct, wrongAnswers: Array(wrongs))
    }

    var questionText: String { "\(a) × \(b) = ?" }
}
