import Foundation

struct Planet: Identifiable, Codable {
    let id: String
    let name: String
    let multiplicationTable: Int   // Welche Malfolge (z.B. 3 = 3er-Reihe)
    let unlockRequirement: String? // ID des vorherigen Planeten (nil = Startplanet)
    let position: CGPointCodable   // Position auf der MapScene

    var isUnlocked: Bool {
        ProgressManager.shared.unlockedPlanets.contains(id)
    }
    var isCompleted: Bool {
        ProgressManager.shared.completedPlanets.contains(id)
    }
}

/// Codable-Wrapper für CGPoint
struct CGPointCodable: Codable {
    var x: Double
    var y: Double
    var cgPoint: CGPoint { CGPoint(x: x, y: y) }
}

// MARK: - Alle Planeten
extension Planet {
    static let all: [Planet] = [
        Planet(id: "planet_1", name: "Sternos",    multiplicationTable: 2, unlockRequirement: nil,        position: .init(x: 0.15, y: 0.5)),
        Planet(id: "planet_2", name: "Duplox",     multiplicationTable: 3, unlockRequirement: "planet_1", position: .init(x: 0.30, y: 0.6)),
        Planet(id: "planet_3", name: "Triplonia",  multiplicationTable: 4, unlockRequirement: "planet_2", position: .init(x: 0.45, y: 0.4)),
        Planet(id: "planet_4", name: "Quartaris",  multiplicationTable: 5, unlockRequirement: "planet_3", position: .init(x: 0.60, y: 0.65)),
        Planet(id: "planet_5", name: "Quintessa",  multiplicationTable: 6, unlockRequirement: "planet_4", position: .init(x: 0.75, y: 0.35)),
        Planet(id: "planet_6", name: "Hexanova",   multiplicationTable: 7, unlockRequirement: "planet_5", position: .init(x: 0.88, y: 0.55)),
    ]

    static func find(id: String) -> Planet? {
        all.first { $0.id == id }
    }
}
