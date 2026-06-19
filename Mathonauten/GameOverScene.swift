import SpriteKit
import UIKit

class GameOverScene: SKScene {

    private let planetIndex: Int
    private let waveIndex: Int
    private var W: CGFloat { size.width }
    private var H: CGFloat { size.height }

    init(planetIndex: Int, waveIndex: Int, size: CGSize) {
        self.planetIndex = planetIndex
        self.waveIndex = waveIndex
        super.init(size: size)
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
    }

    required init?(coder: NSCoder) { fatalError() }

    override func didMove(to view: SKView) {
        backgroundColor = UIColor(hex: "#08102a")
        buildUI()
    }

    private func buildUI() {
        let title = SKLabelNode(text: "Nicht aufgeben!")
        title.fontName = "AvenirNext-Bold"
        title.fontSize = 30
        title.fontColor = .white
        title.verticalAlignmentMode = .center
        title.position = CGPoint(x: 0, y: H * 0.32)
        addChild(title)

        let subtitle = SKLabelNode(text: "Du schaffst das!")
        subtitle.fontName = "AvenirNext-Regular"
        subtitle.fontSize = 16
        subtitle.fontColor = UIColor(hex: "#8899cc")
        subtitle.verticalAlignmentMode = .center
        subtitle.position = CGPoint(x: 0, y: H * 0.23)
        addChild(subtitle)

        let robo = SKSpriteNode(imageNamed: "robo")
        robo.setScale(1.2)
        robo.color = .red
        robo.colorBlendFactor = 0.4
        robo.position = CGPoint(x: 0, y: H * 0.08)
        addChild(robo)

        let retryBtn = SKShapeNode(rectOf: CGSize(width: W - 48, height: 54), cornerRadius: 16)
        retryBtn.fillColor = UIColor(hex: "#534AB7")
        retryBtn.strokeColor = UIColor(hex: "#7a70d4")
        retryBtn.lineWidth = 2
        retryBtn.position = CGPoint(x: 0, y: -H * 0.12)
        retryBtn.name = "retry_btn"
        addChild(retryBtn)

        let retryLabel = SKLabelNode(text: "Nochmal versuchen")
        retryLabel.fontName = "AvenirNext-Bold"
        retryLabel.fontSize = 18
        retryLabel.fontColor = .white
        retryLabel.verticalAlignmentMode = .center
        retryLabel.position = .zero
        retryBtn.addChild(retryLabel)

        let mapBtn = SKShapeNode(rectOf: CGSize(width: W - 48, height: 46), cornerRadius: 14)
        mapBtn.fillColor = UIColor(hex: "#0F6E56")
        mapBtn.strokeColor = UIColor(hex: "#1d9e75")
        mapBtn.lineWidth = 1.5
        mapBtn.position = CGPoint(x: 0, y: -H * 0.23)
        mapBtn.name = "map_btn"
        addChild(mapBtn)

        let mapLabel = SKLabelNode(text: "Zur Karte")
        mapLabel.fontName = "AvenirNext-Regular"
        mapLabel.fontSize = 16
        mapLabel.fontColor = UIColor(hex: "#9fe1cb")
        mapLabel.verticalAlignmentMode = .center
        mapLabel.position = .zero
        mapBtn.addChild(mapLabel)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let node = atPoint(touch.location(in: self))
        let feedback = UIImpactFeedbackGenerator(style: .medium)
        feedback.impactOccurred()

        if node.name == "retry_btn" || node.parent?.name == "retry_btn" {
            let battle = BattleScene(size: size, planetIndex: planetIndex)
            battle.scaleMode = .aspectFill
            battle.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            view?.presentScene(battle, transition: SKTransition.fade(withDuration: 0.4))
        }
        if node.name == "map_btn" || node.parent?.name == "map_btn" {
            let map = MapScene(size: size)
            map.scaleMode = .aspectFill
            map.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            view?.presentScene(map, transition: SKTransition.fade(withDuration: 0.4))
        }
    }
}
