import SpriteKit

class RewardScene: SKScene {

    private let planetID: String
    private var H: CGFloat { size.height }

    init(size: CGSize, planetID: String) {
        self.planetID = planetID
        super.init(size: size)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) not implemented") }

    override func didMove(to view: SKView) {
        let bg = SKSpriteNode(color: UIColor(hex: "#0D0D1A"), size: size)
        bg.position = .zero
        bg.zPosition = -10
        addChild(bg)

        let label = SKLabelNode(text: "🎉 Planet befreit!")
        label.fontName = "AvenirNext-Bold"
        label.fontSize = 36
        label.fontColor = .yellow
        label.verticalAlignmentMode = .center
        label.position = CGPoint(x: 0, y: H * 0.05)
        addChild(label)

        run(.sequence([
            .wait(forDuration: 3.0),
            .run { [weak self] in
                guard let view = self?.view else { return }
                SceneManager.transition(to: .map, from: view)
            }
        ]))
    }
}
