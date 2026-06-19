import SpriteKit

class MenuScene: SKScene {

    private var W: CGFloat { size.width }
    private var H: CGFloat { size.height }

    override func didMove(to view: SKView) {
        setupBackground()
        setupStars()
        setupTitle()
        setupStartButton()
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

    private func setupTitle() {
        let title = SKLabelNode(text: "Mathonauten")
        title.fontName = "AvenirNext-Bold"
        title.fontSize = 48
        title.fontColor = .white
        title.verticalAlignmentMode = .center
        title.position = CGPoint(x: 0, y: H * 0.18)
        addChild(title)

        let subtitle = SKLabelNode(text: "Rette das Universum mit Mathe!")
        subtitle.fontName = "AvenirNext-Regular"
        subtitle.fontSize = 16
        subtitle.fontColor = UIColor(hex: "#A09FD0")
        subtitle.verticalAlignmentMode = .center
        subtitle.position = CGPoint(x: 0, y: H * 0.08)
        addChild(subtitle)
    }

    private func setupStartButton() {
        let btn = SKShapeNode(rectOf: CGSize(width: 220, height: 56), cornerRadius: 16)
        btn.fillColor = UIColor(hex: "#534AB7")
        btn.strokeColor = UIColor(hex: "#7a70d4")
        btn.lineWidth = 2
        btn.position = CGPoint(x: 0, y: -H * 0.10)
        btn.name = "startButton"
        addChild(btn)

        let label = SKLabelNode(text: "Spiel starten")
        label.fontName = "AvenirNext-Bold"
        label.fontSize = 22
        label.fontColor = .white
        label.verticalAlignmentMode = .center
        label.position = CGPoint(x: 0, y: -H * 0.10)
        label.name = "startButtonLabel"
        addChild(label)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        for node in nodes(at: location) {
            if node.name == "startButton" || node.name == "startButtonLabel" {
                guard let view = view else { return }
                SceneManager.transition(to: .map, from: view)
                return
            }
        }
    }
}
