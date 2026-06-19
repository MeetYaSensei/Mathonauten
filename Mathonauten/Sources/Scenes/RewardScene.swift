import SpriteKit

class RewardScene: SKScene {

    private let starsEarned: Int
    private var W: CGFloat { size.width }
    private var H: CGFloat { size.height }

    init(size: CGSize, starsEarned: Int) {
        self.starsEarned = starsEarned
        super.init(size: size)
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
    }

    required init?(coder: NSCoder) { fatalError() }

    override func didMove(to view: SKView) {
        backgroundColor = UIColor(hex: "#08102a")
        buildUI()
        SoundManager.shared.stopBGM()
        SoundManager.shared.playSFX(SoundName.victory)
    }

    private func buildUI() {
        let title = SKLabelNode(text: "Gewonnen! 🎉")
        title.fontName = "AvenirNext-Bold"
        title.fontSize = 28
        title.fontColor = .white
        title.verticalAlignmentMode = .center
        title.position = CGPoint(x: 0, y: H * 0.25)
        addChild(title)

        for i in 0..<3 {
            let star = SKLabelNode(text: i < starsEarned ? "⭐" : "☆")
            star.fontSize = 36
            star.verticalAlignmentMode = .center
            star.position = CGPoint(x: CGFloat(i - 1) * 50, y: H * 0.12)
            addChild(star)
        }

        let rewardLabel = SKLabelNode(text: "+\(starsEarned * 10) Sterne")
        rewardLabel.fontName = "AvenirNext-Regular"
        rewardLabel.fontSize = 16
        rewardLabel.fontColor = UIColor(hex: "#eedd88")
        rewardLabel.verticalAlignmentMode = .center
        rewardLabel.position = CGPoint(x: 0, y: H * 0.02)
        addChild(rewardLabel)

        let nextBtn = SKShapeNode(rectOf: CGSize(width: W - 60, height: 52), cornerRadius: 16)
        nextBtn.fillColor = UIColor(hex: "#0F6E56")
        nextBtn.strokeColor = UIColor(hex: "#1d9e75")
        nextBtn.lineWidth = 2
        nextBtn.position = CGPoint(x: 0, y: -H * 0.15)
        nextBtn.name = "nextBtn"
        addChild(nextBtn)

        let nextLabel = SKLabelNode(text: "Weiter →")
        nextLabel.fontName = "AvenirNext-Bold"
        nextLabel.fontSize = 18
        nextLabel.fontColor = UIColor(hex: "#9fe1cb")
        nextLabel.verticalAlignmentMode = .center
        nextLabel.position = .zero
        nextBtn.addChild(nextLabel)

        let hubBtn = SKShapeNode(rectOf: CGSize(width: W - 60, height: 44), cornerRadius: 14)
        hubBtn.fillColor = UIColor(hex: "#131d3a")
        hubBtn.strokeColor = UIColor(hex: "#2a3a6e")
        hubBtn.position = CGPoint(x: 0, y: -H * 0.26)
        hubBtn.name = "hubBtn"
        addChild(hubBtn)

        let hubLabel = SKLabelNode(text: "Zum Hub")
        hubLabel.fontName = "AvenirNext-Regular"
        hubLabel.fontSize = 15
        hubLabel.fontColor = UIColor(hex: "#8899cc")
        hubLabel.verticalAlignmentMode = .center
        hubLabel.position = .zero
        hubBtn.addChild(hubLabel)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let loc = touch.location(in: self)
        let node = atPoint(loc)

        if node.name == "nextBtn" || node.parent?.name == "nextBtn" {
            SoundManager.shared.playSFX(SoundName.tap)
            let battle = BattleScene(size: size)
            battle.scaleMode = .aspectFill
            battle.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            view?.presentScene(battle, transition: SKTransition.fade(withDuration: 0.5))
        }
        if node.name == "hubBtn" || node.parent?.name == "hubBtn" {
            SoundManager.shared.playSFX(SoundName.tap)
            let hub = HubScene(size: size)
            hub.scaleMode = .aspectFill
            hub.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            view?.presentScene(hub, transition: SKTransition.fade(withDuration: 0.5))
        }
    }
}
