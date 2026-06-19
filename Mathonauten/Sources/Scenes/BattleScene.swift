import SpriteKit

class BattleScene: SKScene {

    private let planetID: String
    private var currentQuestion: MathQuestion?
    private var playerHP = 3
    private var enemyHP  = 5
    private var streak   = 0

    private var W: CGFloat { size.width }
    private var H: CGFloat { size.height }

    init(size: CGSize, planetID: String) {
        self.planetID = planetID
        super.init(size: size)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) not implemented") }

    override func didMove(to view: SKView) {
        setupBackground()
        setupStars()
        setupTopBar()
        setupEnemy()
        setupEnemyHP()
        setupStreakDots()
        setupQuestionPanel()
        setupAnswerButtons()
        setupPlayerHP()
        setupRoboPanel()

        guard let planet = Planet.find(id: planetID) else { return }
        nextQuestion(table: planet.multiplicationTable)
        print("BattleScene loaded – Portrait \(W)×\(H)")
    }

    // MARK: - Background

    private func setupBackground() {
        let bg = SKSpriteNode(color: UIColor(hex: "#0D0D1A"), size: size)
        bg.position = .zero
        bg.zPosition = -10
        addChild(bg)
    }

    private func setupStars() {
        for _ in 0..<60 {
            let r = CGFloat.random(in: 1.5...2.5)
            let star = SKShapeNode(circleOfRadius: r)
            star.fillColor = .white
            star.strokeColor = .clear
            star.alpha = CGFloat.random(in: 0.4...0.9)
            star.position = CGPoint(x: CGFloat.random(in: -W/2...W/2),
                                    y: CGFloat.random(in: -H/2...H/2))
            star.zPosition = -9
            addChild(star)
        }
    }

    // MARK: - Top Bar

    private func setupTopBar() {
        let planet = Planet.find(id: planetID)
        let y = H * 0.44

        let leftLabel = SKLabelNode(text: planet?.name ?? "Planet")
        leftLabel.fontName = "AvenirNext-Regular"
        leftLabel.fontSize = 11
        leftLabel.fontColor = UIColor(hex: "#8899cc")
        leftLabel.horizontalAlignmentMode = .left
        leftLabel.verticalAlignmentMode = .center
        leftLabel.position = CGPoint(x: -W / 3, y: y)
        addChild(leftLabel)

        let badge = SKShapeNode(rectOf: CGSize(width: 72, height: 20), cornerRadius: 6)
        badge.fillColor = UIColor(hex: "#1a2a5e")
        badge.strokeColor = UIColor(hex: "#3a4a9e")
        badge.lineWidth = 1
        badge.position = CGPoint(x: 0, y: y)
        addChild(badge)

        let waveLabel = SKLabelNode(text: "Welle 1/3")
        waveLabel.fontName = "AvenirNext-Regular"
        waveLabel.fontSize = 11
        waveLabel.fontColor = UIColor(hex: "#8899cc")
        waveLabel.verticalAlignmentMode = .center
        waveLabel.position = CGPoint(x: 0, y: y)
        addChild(waveLabel)

        let tableText = planet != nil ? "\(planet!.multiplicationTable)er-Reihe" : "Reihe"
        let rightLabel = SKLabelNode(text: tableText)
        rightLabel.fontName = "AvenirNext-Regular"
        rightLabel.fontSize = 11
        rightLabel.fontColor = UIColor(hex: "#8899cc")
        rightLabel.horizontalAlignmentMode = .right
        rightLabel.verticalAlignmentMode = .center
        rightLabel.position = CGPoint(x: W / 3, y: y)
        addChild(rightLabel)
    }

    // MARK: - Enemy

    private func setupEnemy() {
        let cy = H * 0.25

        let body = SKShapeNode(circleOfRadius: 38)
        body.fillColor = UIColor(hex: "#3A7D44")
        body.strokeColor = .clear
        body.position = CGPoint(x: 0, y: cy)
        addChild(body)

        for xOff: CGFloat in [-13, 13] {
            let white = SKShapeNode(circleOfRadius: 7)
            white.fillColor = .white
            white.strokeColor = .clear
            white.position = CGPoint(x: xOff, y: cy - 8)
            addChild(white)

            let pupil = SKShapeNode(circleOfRadius: 4)
            pupil.fillColor = .black
            pupil.strokeColor = .clear
            pupil.position = CGPoint(x: xOff, y: cy - 8)
            addChild(pupil)
        }

        let mouthPath = CGMutablePath()
        mouthPath.addArc(center: .zero, radius: 6,
                         startAngle: .pi, endAngle: 0, clockwise: true)
        let mouth = SKShapeNode(path: mouthPath)
        mouth.strokeColor = .black
        mouth.fillColor = .clear
        mouth.lineWidth = 2
        mouth.position = CGPoint(x: 0, y: cy - 18)
        addChild(mouth)

        let nameLabel = SKLabelNode(text: "Glob-Alien")
        nameLabel.fontName = "AvenirNext-Regular"
        nameLabel.fontColor = .white
        nameLabel.fontSize = 13
        nameLabel.verticalAlignmentMode = .center
        nameLabel.position = CGPoint(x: 0, y: H * 0.22)
        addChild(nameLabel)
    }

    // MARK: - Enemy HP

    private func setupEnemyHP() {
        let y = H * 0.18

        let barBg = SKShapeNode(rectOf: CGSize(width: 180, height: 10), cornerRadius: 5)
        barBg.fillColor = UIColor(hex: "#1A1A2E")
        barBg.strokeColor = .clear
        barBg.position = CGPoint(x: 0, y: y)
        addChild(barBg)

        let barFill = SKShapeNode(rectOf: CGSize(width: 180, height: 10), cornerRadius: 5)
        barFill.fillColor = UIColor(hex: "#1d9e75")
        barFill.strokeColor = .clear
        barFill.position = CGPoint(x: 0, y: y)
        barFill.name = "enemyHPBar"
        addChild(barFill)

        let hpLabel = SKLabelNode(text: "HP 5/5")
        hpLabel.fontName = "AvenirNext-Regular"
        hpLabel.fontColor = UIColor(hex: "#8899cc")
        hpLabel.fontSize = 10
        hpLabel.verticalAlignmentMode = .center
        hpLabel.position = CGPoint(x: 0, y: y - 13)
        hpLabel.name = "enemyHPLabel"
        addChild(hpLabel)
    }

    // MARK: - Streak Dots

    private func setupStreakDots() {
        let y = H * 0.12
        let spacing: CGFloat = 18
        let startX = -CGFloat(4) * spacing / 2

        for i in 0..<5 {
            let dot = SKShapeNode(circleOfRadius: 5)
            dot.fillColor = UIColor(hex: "#1a2a5e")
            dot.strokeColor = UIColor(hex: "#3a4a9e")
            dot.lineWidth = 1
            dot.position = CGPoint(x: startX + CGFloat(i) * spacing, y: y)
            dot.name = "streak_\(i)"
            addChild(dot)
        }
    }

    private func updateStreakDots() {
        for i in 0..<5 {
            if let dot = childNode(withName: "streak_\(i)") as? SKShapeNode {
                dot.fillColor = i < streak ? UIColor(hex: "#e07030") : UIColor(hex: "#1a2a5e")
            }
        }
    }

    // MARK: - Question Panel

    private func setupQuestionPanel() {
        let cy = H * 0.02

        let panel = SKShapeNode(rectOf: CGSize(width: W - 40, height: 90), cornerRadius: 16)
        panel.fillColor = UIColor(hex: "#1E1B4B")
        panel.strokeColor = .clear
        panel.position = CGPoint(x: 0, y: cy)
        addChild(panel)

        let hint = SKLabelNode(text: "Welches Ergebnis ist richtig?")
        hint.fontName = "AvenirNext-Regular"
        hint.fontSize = 10
        hint.fontColor = UIColor(hex: "#8899cc")
        hint.verticalAlignmentMode = .center
        hint.position = CGPoint(x: 0, y: cy + 26)
        addChild(hint)

        let label = SKLabelNode(text: "? × ? = ?")
        label.fontColor = .white
        label.fontSize = 26
        label.fontName = "AvenirNext-Bold"
        label.verticalAlignmentMode = .center
        label.position = CGPoint(x: 0, y: cy - 4)
        label.name = "questionLabel"
        addChild(label)
    }

    // MARK: - Answer Buttons

    private func setupAnswerButtons() {
        let answers = ["?", "?", "?", "?"]
        let btnW = W / 2 - 24
        let positions: [CGPoint] = [
            CGPoint(x: -W / 4, y: -H * 0.10),
            CGPoint(x:  W / 4, y: -H * 0.10),
            CGPoint(x: -W / 4, y: -H * 0.20),
            CGPoint(x:  W / 4, y: -H * 0.20)
        ]

        for i in 0..<4 {
            let btn = SKShapeNode(rectOf: CGSize(width: btnW, height: 64), cornerRadius: 14)
            btn.fillColor = UIColor(hex: "#534AB7")
            btn.strokeColor = UIColor(hex: "#7a70d4")
            btn.lineWidth = 2
            btn.position = positions[i]
            btn.name = "answer_\(i)"
            addChild(btn)

            let label = SKLabelNode(text: answers[i])
            label.fontColor = .white
            label.fontSize = 22
            label.fontName = "AvenirNext-Bold"
            label.verticalAlignmentMode = .center
            label.position = positions[i]
            label.name = "answer_\(i)_label"
            addChild(label)
        }
    }

    // MARK: - Player HP

    private func setupPlayerHP() {
        let x = -W / 4
        let y = -H * 0.38

        let barBg = SKShapeNode(rectOf: CGSize(width: 130, height: 10), cornerRadius: 5)
        barBg.fillColor = UIColor(hex: "#1A1A2E")
        barBg.strokeColor = .clear
        barBg.position = CGPoint(x: x, y: y)
        addChild(barBg)

        let barFill = SKShapeNode(rectOf: CGSize(width: 130, height: 10), cornerRadius: 5)
        barFill.fillColor = UIColor(hex: "#e07030")
        barFill.strokeColor = .clear
        barFill.position = CGPoint(x: x, y: y)
        barFill.name = "playerHPBar"
        addChild(barFill)

        let hpLabel = SKLabelNode(text: "HP \(playerHP)/3")
        hpLabel.fontName = "AvenirNext-Regular"
        hpLabel.fontColor = UIColor(hex: "#8899cc")
        hpLabel.fontSize = 10
        hpLabel.verticalAlignmentMode = .center
        hpLabel.position = CGPoint(x: x, y: y - 13)
        hpLabel.name = "playerHPLabel"
        addChild(hpLabel)
    }

    // MARK: - Robo Panel

    private func setupRoboPanel() {
        let cx = W / 4
        let cy = -H * 0.38

        let icon = SKShapeNode(rectOf: CGSize(width: 28, height: 28), cornerRadius: 6)
        icon.fillColor = UIColor(hex: "#1a2a5e")
        icon.strokeColor = UIColor(hex: "#3a4a9e")
        icon.lineWidth = 1
        icon.position = CGPoint(x: cx - 52, y: cy)
        addChild(icon)

        let roboLabel = SKLabelNode(text: "🤖")
        roboLabel.fontSize = 16
        roboLabel.verticalAlignmentMode = .center
        roboLabel.position = CGPoint(x: cx - 52, y: cy)
        addChild(roboLabel)

        let speech = SKShapeNode(rectOf: CGSize(width: 80, height: 26), cornerRadius: 6)
        speech.fillColor = UIColor(hex: "#1a2a5e")
        speech.strokeColor = UIColor(hex: "#3a4a9e")
        speech.lineWidth = 1
        speech.position = CGPoint(x: cx + 2, y: cy)
        addChild(speech)

        let speechLabel = SKLabelNode(text: "Du schaffst das!")
        speechLabel.fontName = "AvenirNext-Regular"
        speechLabel.fontSize = 10
        speechLabel.fontColor = UIColor(hex: "#aabbee")
        speechLabel.verticalAlignmentMode = .center
        speechLabel.position = CGPoint(x: cx + 2, y: cy)
        addChild(speechLabel)
    }

    // MARK: - Touch

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        for node in nodes(at: location) {
            guard let name = node.name, name.hasPrefix("answer_"), !name.hasSuffix("_label") else { continue }
            if let index = Int(name.replacingOccurrences(of: "answer_", with: "")),
               let q = currentQuestion {
                answerSelected(q.allAnswers[index])
            }
            break
        }
    }

    // MARK: - Game Logic

    func nextQuestion(table: Int) {
        currentQuestion = MathQuestion.generate(table: table)
        guard let q = currentQuestion else { return }
        if let label = childNode(withName: "questionLabel") as? SKLabelNode {
            label.text = q.questionText
        }
        let shuffled = q.allAnswers
        for i in 0..<4 {
            if let label = childNode(withName: "answer_\(i)_label") as? SKLabelNode {
                label.text = "\(shuffled[i])"
            }
        }
    }

    func answerSelected(_ answer: Int) {
        guard let q = currentQuestion else { return }
        if answer == q.correctAnswer {
            enemyHP -= 1
            streak = min(streak + 1, 5)
            updateEnemyHP()
            updateStreakDots()
            if enemyHP <= 0 { battleWon(); return }
        } else {
            playerHP -= 1
            streak = 0
            updatePlayerHP()
            updateStreakDots()
            if playerHP <= 0 { battleLost(); return }
        }
        guard let planet = Planet.find(id: planetID) else { return }
        nextQuestion(table: planet.multiplicationTable)
    }

    private func updateEnemyHP() {
        if let label = childNode(withName: "enemyHPLabel") as? SKLabelNode {
            label.text = "HP \(enemyHP)/5"
        }
        if let bar = childNode(withName: "enemyHPBar") as? SKShapeNode {
            bar.xScale = max(CGFloat(enemyHP) / 5.0, 0)
        }
    }

    private func updatePlayerHP() {
        if let label = childNode(withName: "playerHPLabel") as? SKLabelNode {
            label.text = "HP \(playerHP)/3"
        }
        if let bar = childNode(withName: "playerHPBar") as? SKShapeNode {
            bar.xScale = max(CGFloat(playerHP) / 3.0, 0)
        }
    }

    private func battleWon() {
        ProgressManager.shared.completePlanet(planetID)
        if let next = Planet.all.first(where: { $0.unlockRequirement == planetID }) {
            ProgressManager.shared.unlockPlanet(next.id)
        }
        guard let view = view else { return }
        SceneManager.transition(to: .reward(planetID: planetID), from: view)
    }

    private func battleLost() {
        guard let view = view else { return }
        SceneManager.transition(to: .hub, from: view)
    }
}
