import Foundation
import Combine

/// Verwaltet den gesamten Spielfortschritt – persistent via UserDefaults.
final class ProgressManager: ObservableObject {

    static let shared = ProgressManager()

    // MARK: - Keys
    private enum Keys {
        static let unlockedPlanets   = "unlockedPlanets"
        static let completedPlanets  = "completedPlanets"
        static let collectedRewards  = "collectedRewards"
        static let highScores        = "highScores"
        static let roboUnlocked      = "roboUnlocked"
        static let cosmoUnlocked     = "cosmoUnlocked"
    }

    // MARK: - Published State
    @Published var unlockedPlanets:  Set<String>
    @Published var completedPlanets: Set<String>
    @Published var collectedRewards: Set<String>
    @Published var highScores:       [String: Int]
    @Published var isRoboUnlocked:   Bool
    @Published var isCosmoUnlocked:  Bool

    // MARK: - Init
    private init() {
        let ud = UserDefaults.standard
        unlockedPlanets  = Set(ud.stringArray(forKey: Keys.unlockedPlanets)  ?? ["planet_1"])
        completedPlanets = Set(ud.stringArray(forKey: Keys.completedPlanets) ?? [])
        collectedRewards = Set(ud.stringArray(forKey: Keys.collectedRewards) ?? [])
        highScores       = ud.dictionary(forKey: Keys.highScores) as? [String: Int] ?? [:]
        isRoboUnlocked   = ud.bool(forKey: Keys.roboUnlocked)
        isCosmoUnlocked  = ud.bool(forKey: Keys.cosmoUnlocked)
    }

    // MARK: - Save
    func save() {
        let ud = UserDefaults.standard
        ud.set(Array(unlockedPlanets),  forKey: Keys.unlockedPlanets)
        ud.set(Array(completedPlanets), forKey: Keys.completedPlanets)
        ud.set(Array(collectedRewards), forKey: Keys.collectedRewards)
        ud.set(highScores,              forKey: Keys.highScores)
        ud.set(isRoboUnlocked,          forKey: Keys.roboUnlocked)
        ud.set(isCosmoUnlocked,         forKey: Keys.cosmoUnlocked)
    }

    // MARK: - Actions
    func unlockPlanet(_ id: String) {
        unlockedPlanets.insert(id)
        save()
    }

    func completePlanet(_ id: String) {
        completedPlanets.insert(id)
        save()
    }

    func collectReward(_ id: String) {
        collectedRewards.insert(id)
        save()
    }

    func updateHighScore(planetID: String, score: Int) {
        if score > (highScores[planetID] ?? 0) {
            highScores[planetID] = score
            save()
        }
    }

    func unlockRobo() {
        isRoboUnlocked = true
        save()
    }

    func unlockCosmo() {
        isCosmoUnlocked = true
        save()
    }

    /// Setzt alles zurück (Debug / Einstellungen)
    func resetAll() {
        unlockedPlanets  = ["planet_1"]
        completedPlanets = []
        collectedRewards = []
        highScores       = [:]
        isRoboUnlocked   = false
        isCosmoUnlocked  = false
        save()
    }
}
