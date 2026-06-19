# Mathonauten 🚀

Kinderfreundliches Mathe-Rollenspiel im Weltraum.  
Malfolgen-Aufgaben lösen Kämpfe, schalten Planeten frei und erzählen eine Story.

## Projektstruktur

```
Mathonauten/
├── Mathonauten.xcodeproj/
└── Mathonauten/
    └── Sources/
        ├── App/
        │   ├── AppDelegate.swift        – App-Entry-Point
        │   └── GameViewController.swift – SKView Setup
        ├── Scenes/
        │   ├── MenuScene.swift          – Hauptmenü
        │   ├── MapScene.swift           – Universum-Karte
        │   ├── BattleScene.swift        – Kampf + Malfolgen
        │   └── RewardScene.swift        – Belohnungs-Cutscene
        ├── Systems/
        │   ├── ProgressManager.swift    – Spielstand (UserDefaults)
        │   ├── SceneManager.swift       – Szenen-Navigation
        │   └── DialogSystem.swift       – Robo-Dialoge
        └── Models/
            ├── Planet.swift             – Planet-Datenmodell
            └── MathQuestion.swift       – Malfolgen-Aufgaben
```

## Charaktere
- **Leo** – Astronaut-Kind, Spieler-Charakter
- **Robo** – Roboter-Begleiter, gibt Hinweise
- **Cosmo-1** – Raumschiff

## Tech-Stack
Swift 5.9 · SpriteKit · iOS 16+ / macOS 13+ · Xcode 15+ · Kein Backend

## Nächste Schritte
1. [ ] BattleScene UI implementieren
2. [ ] MapScene mit Planeten-Buttons
3. [ ] MenuScene Design
4. [ ] DialogSystem in BattleScene integrieren
