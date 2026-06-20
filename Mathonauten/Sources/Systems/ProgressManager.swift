import Foundation

final class ProgressManager {
    static let shared = ProgressManager()
    private let defaults = UserDefaults.standard
    private init() {}

    var currentPlanetIndex: Int {
        get { defaults.integer(forKey: "currentPlanetIndex") }
        set { defaults.set(newValue, forKey: "currentPlanetIndex") }
    }
    var currentWaveIndex: Int {
        get { defaults.integer(forKey: "currentWaveIndex") }
        set { defaults.set(newValue, forKey: "currentWaveIndex") }
    }
    var unlockedPlanets: Set<Int> {
        get { Set(defaults.array(forKey: "unlockedPlanets") as? [Int] ?? [0]) }
        set { defaults.set(Array(newValue), forKey: "unlockedPlanets") }
    }
    var stars: Int {
        get { defaults.integer(forKey: "stars") }
        set { defaults.set(newValue, forKey: "stars") }
    }
    var gems: Int {
        get { defaults.integer(forKey: "gems") }
        set { defaults.set(newValue, forKey: "gems") }
    }

    struct PlanetData {
        let name: String
        let multiplicationTable: Int
        let totalWaves: Int
        let color: String
    }

    let planets: [PlanetData] = [
        PlanetData(name: "Erde",     multiplicationTable: 2, totalWaves: 5, color: "#1d7a44"),
        PlanetData(name: "Flammos",  multiplicationTable: 3, totalWaves: 5, color: "#9a3c1d"),
        PlanetData(name: "Frostara", multiplicationTable: 4, totalWaves: 5, color: "#1a5a8a"),
        PlanetData(name: "Bluma",    multiplicationTable: 5, totalWaves: 5, color: "#3b6d11"),
        PlanetData(name: "Astrox",   multiplicationTable: 6, totalWaves: 8, color: "#6a2a8a"),
    ]

    var currentPlanet: PlanetData { planets[currentPlanetIndex] }

    var planetProgress: Float {
        Float(currentWaveIndex) / Float(currentPlanet.totalWaves)
    }

    func completeWave(starsEarned: Int) {
        stars += starsEarned
        currentWaveIndex += 1
        if currentWaveIndex >= currentPlanet.totalWaves {
            let next = currentPlanetIndex + 1
            if next < planets.count {
                var unlocked = unlockedPlanets
                unlocked.insert(next)
                unlockedPlanets = unlocked
                currentPlanetIndex = next
                currentWaveIndex = 0
            }
        }
    }

    func failWave() {}

    func addGems(_ amount: Int) {
        gems += amount
    }

    var hubProgressText: String {
        "\(currentPlanet.name) · \(currentPlanet.multiplicationTable)er-Reihe"
    }
    var hubLevelText: String {
        "Level \(currentWaveIndex)/\(currentPlanet.totalWaves)"
    }
}
