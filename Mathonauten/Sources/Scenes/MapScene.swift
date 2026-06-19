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
        let colors: [String] = ["#3A7D44","#E25822","#4FC3F7","#66BB6A","#9C27B0","#FF7043"]
        let portraitPositions: [CGPoint] = [
            CGPoint(x: 0,          y:  H * 0.30),
            CGPoint(x:  W * 0.15,  y:  H * 0.10),
            CGPoint(x: -W * 0.15,  y: -H * 0.10),
            CGPoint(x:  W * 0.10,  y: -H * 0.28),
            CGPoint(x:  0,         y: -H * 0.42),
            CGPoint(x: -W * 0.10,  y: -H * 0.52),
        ]

        let planets = Planet.all
        for i in 0..<min(planets.count, portraitPositions.count) {
            let planet = planets[i]
            let pos = portraitPositions[i]

            if i > 0 {
                let prevPos = portraitPositions[i - 1]
                let line = lineBetween(prevPos, pos)
                addChild(line)
            }

            let radius: CGFloat = 32
            let circle = SKShapeNode(circleOfRadius: radius)
            circle.fillColor = UIColor(hex: colors[i % colors.count])
            circle.strokeColor = .clear
            circle.position = pos
            circle.name = "planet_\(planet.id)"
            circle.alpha = planet.isUnlocked ? 1.0 : 0.35
            addChild(circle)

            let nameLabel = SKLabelNode(text: planet.name)
            nameLabel.fontName = "AvenirNext-Bold"
            nameLabel.fontSize = 12
            nameLabel.fontColor = .white
            nameLabel.verticalAlignmentMode = .center
            nameLabel.position = CGPoint(x: pos.x, y: pos.y - radius - 14)
            nameLabel.name = "label_\(planet.id)"
            addChild(nameLabel)

            if planet.isCompleted {
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
        let nodes = self.nodes(at: location)
        print("MapScene Touch bei: \(location)")
        print("Getroffene Nodes: \(nodes.map { $0.name ?? "kein Name" })")

        for node in nodes {
            guard let name = node.name else { continue }
            if name == "btn_back" {
                guard let view = view else { return }
                SceneManager.transition(to: .hub, from: view)
                return
            }
            var planetID = ""
            if name.hasPrefix("planet_") {
                planetID = name.replacingOccurrences(of: "planet_", with: "")
            } else if name.hasPrefix("label_") {
                planetID = name.replacingOccurrences(of: "label_", with: "")
            } else { continue }

            print("PlanetID: \(planetID)")
            guard let planet = Planet.find(id: planetID), planet.isUnlocked else {
                print("Planet gesperrt oder nicht gefunden")
                return
            }
            guard let view = view else { return }
            SceneManager.transition(to: .battle(planetID: planetID), from: view)
            return
        }
        print("Kein Planet-Node getroffen")
    }
}
