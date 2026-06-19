import SpriteKit

class MapScene: SKScene {

    private var W: CGFloat { size.width }
    private var H: CGFloat { size.height }

    override func didMove(to view: SKView) {
        setupBackground()
        setupStars()
        setupBackButton()
        setupTitle()
        setupPlanets()
    }

    private func setupBackground() {
        let bg = SKSpriteNode(color: UIColor(hex: "#0D0D1A"), size: size)
        bg.position = .zero
        bg.zPosition = -10
        addChild(bg)
    }

    private func setupStars() {
        for _ in 0..<80 {
            let r = CGFloat.random(in: 1.0...2.5)
            let star = SKShapeNode(circleOfRadius: r)
            star.fillColor = .white
            star.strokeColor = .clear
            star.alpha = CGFloat.random(in: 0.3...0.9)
            star.position = CGPoint(x: CGFloat.random(in: -W/2...W/2),
                                    y: CGFloat.random(in: -H/2...H/2))
            star.zPosition = -9
            addChild(star)
        }
    }

    private func setupBackButton() {
        let btn = SKShapeNode(rectOf: CGSize(width: 60, height: 28), cornerRadius: 8)
        btn.fillColor = UIColor(hex: "#131d3a")
        btn.strokeColor = UIColor(hex: "#2a3a6e")
        btn.lineWidth = 1
        btn.position = CGPoint(x: -W/2 + 40, y: H * 0.42)
        btn.name = "btn_back"
        addChild(btn)

        let backLabel = SKLabelNode(text: "← Hub")
        backLabel.fontName = "AvenirNext-Regular"
        backLabel.fontSize = 11
        backLabel.fontColor = UIColor(hex: "#aabbee")
        backLabel.verticalAlignmentMode = .center
        backLabel.position = CGPoint(x: -W/2 + 40, y: H * 0.42)
        backLabel.name = "btn_back"
        addChild(backLabel)
    }

    private func setupTitle() {
        let label = SKLabelNode(text: "Universumskarte")
        label.fontName = "AvenirNext-Bold"
        label.fontSize = 26
        label.fontColor = .white
        label.verticalAlignmentMode = .center
        label.position = CGPoint(x: 0, y: H * 0.42)
        addChild(label)
    }

    private func setupPlanets() {
        let pm = ProgressManager.shared
        let portraitPositions: [CGPoint] = [
            CGPoint(x: 0,         y:  H * 0.30),
            CGPoint(x:  W * 0.15, y:  H * 0.10),
            CGPoint(x: -W * 0.15, y: -H * 0.10),
            CGPoint(x:  W * 0.10, y: -H * 0.28),
            CGPoint(x:  0,        y: -H * 0.42),
        ]

        for (i, planet) in pm.planets.enumerated() {
            guard i < portraitPositions.count else { break }
            let pos = portraitPositions[i]
            let isUnlocked = pm.unlockedPlanets.contains(i)
            let isCompleted = pm.currentPlanetIndex > i

            if i > 0 {
                let prevPos = portraitPositions[i - 1]
                addChild(lineBetween(prevPos, pos))
            }

            let circle = SKShapeNode(circleOfRadius: 32)
            circle.fillColor = UIColor(hex: planet.color)
            circle.strokeColor = .clear
            circle.position = pos
            circle.name = "planet_\(i)"
            circle.alpha = isUnlocked ? 1.0 : 0.35
            addChild(circle)

            let nameLabel = SKLabelNode(text: planet.name)
            nameLabel.fontName = "AvenirNext-Bold"
            nameLabel.fontSize = 12
            nameLabel.fontColor = .white
            nameLabel.verticalAlignmentMode = .center
            nameLabel.position = CGPoint(x: pos.x, y: pos.y - 46)
            nameLabel.name = "label_\(i)"
            addChild(nameLabel)

            if isCompleted {
                let check = SKLabelNode(text: "✓")
                check.fontSize = 18
                check.fontColor = UIColor(hex: "#1d9e75")
                check.verticalAlignmentMode = .center
                check.position = pos
                addChild(check)
            }
        }
    }

    private func lineBetween(_ a: CGPoint, _ b: CGPoint) -> SKShapeNode {
        let path = CGMutablePath()
        path.move(to: a)
        path.addLine(to: b)
        let line = SKShapeNode(path: path)
        line.strokeColor = UIColor(hex: "#3a4a9e")
        line.lineWidth = 1.5
        line.zPosition = -1
        return line
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)

        for node in nodes(at: location) {
            guard let name = node.name else { continue }
            if name == "btn_back" {
                guard let view = view else { return }
                SceneManager.transition(to: .hub, from: view)
                return
            }
            var idx = -1
            if name.hasPrefix("planet_") {
                idx = Int(name.replacingOccurrences(of: "planet_", with: "")) ?? -1
            } else if name.hasPrefix("label_") {
                idx = Int(name.replacingOccurrences(of: "label_", with: "")) ?? -1
            }
            guard idx >= 0, ProgressManager.shared.unlockedPlanets.contains(idx) else { continue }
            guard let view = view else { return }
            SceneManager.transition(to: .battle(planetIndex: idx), from: view)
            return
        }
    }
}
