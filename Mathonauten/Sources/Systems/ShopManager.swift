import Foundation

struct ShopItem: Codable {
    let id: String
    let category: ShopCategory
    let name: String
    let description: String
    let price: Int
    var isPurchased: Bool
    var isEquipped: Bool
}

enum ShopCategory: String, Codable, CaseIterable {
    case powerup
    case roboSkin
    case alienSkin
    case planetTheme
}

final class ShopManager {
    static let shared = ShopManager()
    private let defaults = UserDefaults.standard
    private let itemsKey = "shopItems_v1"
    private let powerupCountKey = "powerupCounts_v1"

    private(set) var items: [ShopItem] = []
    private var powerupCounts: [String: Int] = [:]

    private init() { loadOrSeedItems() }

    private func seedItems() -> [ShopItem] {
        [
            ShopItem(id: "hint",         category: .powerup,     name: "Hinweis",          description: "Zeigt die richtige Antwort",    price: 15,  isPurchased: false, isEquipped: false),
            ShopItem(id: "timebonus",    category: .powerup,     name: "Zeitbonus",        description: "+10 Sekunden pro Frage",         price: 20,  isPurchased: false, isEquipped: false),
            ShopItem(id: "shield",       category: .powerup,     name: "Schutzschild",     description: "Kein HP-Verlust bei Fehler",    price: 30,  isPurchased: false, isEquipped: false),
            ShopItem(id: "robo_blue",    category: .roboSkin,    name: "Robo Blau",        description: "Robo in leuchtendem Blau",      price: 40,  isPurchased: false, isEquipped: false),
            ShopItem(id: "robo_red",     category: .roboSkin,    name: "Robo Rot",         description: "Robo in feurigem Rot",          price: 40,  isPurchased: false, isEquipped: false),
            ShopItem(id: "robo_gold",    category: .roboSkin,    name: "Robo Gold",        description: "Goldener Robo – sehr selten!",  price: 100, isPurchased: false, isEquipped: false),
            ShopItem(id: "robo_hat",     category: .roboSkin,    name: "Astronauten-Helm", description: "Robo mit Helm",                price: 60,  isPurchased: false, isEquipped: false),
            ShopItem(id: "alien_pink",   category: .alienSkin,   name: "Pink-Alien",       description: "Glob-Alien in Pink",            price: 50,  isPurchased: false, isEquipped: false),
            ShopItem(id: "alien_lila",   category: .alienSkin,   name: "Lila-Alien",       description: "Glob-Alien in Lila",            price: 50,  isPurchased: false, isEquipped: false),
            ShopItem(id: "alien_gold",   category: .alienSkin,   name: "Gold-Alien",       description: "Goldener Glob – Prestige!",     price: 120, isPurchased: false, isEquipped: false),
            ShopItem(id: "theme_neon",   category: .planetTheme, name: "Neon-Universum",   description: "Neon-Farben auf der Karte",     price: 100, isPurchased: false, isEquipped: false),
            ShopItem(id: "theme_pastel", category: .planetTheme, name: "Pastell-Galaxie",  description: "Sanfte Pastellfarben",          price: 100, isPurchased: false, isEquipped: false),
            ShopItem(id: "theme_dark",   category: .planetTheme, name: "Dark Mode",        description: "Noch dunkleres Universum",      price: 80,  isPurchased: false, isEquipped: false),
        ]
    }

    private func loadOrSeedItems() {
        var seed = seedItems()
        if let data = defaults.data(forKey: itemsKey),
           let saved = try? JSONDecoder().decode([ShopItem].self, from: data) {
            for s in saved {
                if let idx = seed.firstIndex(where: { $0.id == s.id }) {
                    seed[idx].isPurchased = s.isPurchased
                    seed[idx].isEquipped  = s.isEquipped
                }
            }
        }
        items = seed
        powerupCounts = defaults.dictionary(forKey: powerupCountKey) as? [String: Int] ?? [:]
    }

    func saveItems() {
        if let data = try? JSONEncoder().encode(items) {
            defaults.set(data, forKey: itemsKey)
        }
        defaults.set(powerupCounts, forKey: powerupCountKey)
    }

    func purchase(itemId: String) -> Bool {
        guard let idx = items.firstIndex(where: { $0.id == itemId }) else { return false }
        let item = items[idx]
        guard ProgressManager.shared.gems >= item.price else { return false }
        ProgressManager.shared.spendGems(item.price)
        if item.category == .powerup {
            powerupCounts[itemId, default: 0] += 3
        } else {
            items[idx].isPurchased = true
        }
        saveItems()
        return true
    }

    func equip(itemId: String) {
        guard let idx = items.firstIndex(where: { $0.id == itemId }),
              items[idx].isPurchased else { return }
        let category = items[idx].category
        for i in items.indices where items[i].category == category {
            items[i].isEquipped = false
        }
        items[idx].isEquipped = true
        saveItems()
    }

    func powerupCount(for id: String) -> Int {
        powerupCounts[id, default: 0]
    }

    func usePowerup(id: String) -> Bool {
        guard powerupCounts[id, default: 0] > 0 else { return false }
        powerupCounts[id]! -= 1
        saveItems()
        return true
    }

    func equippedItem(in category: ShopCategory) -> ShopItem? {
        items.first { $0.category == category && $0.isEquipped }
    }

    func items(in category: ShopCategory) -> [ShopItem] {
        items.filter { $0.category == category }
    }
}
