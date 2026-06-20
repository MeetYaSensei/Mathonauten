import SpriteKit
import UIKit

class DailyChallengeScene: SKScene {

    private var W: CGFloat { size.width }
    private var H: CGFloat { size.height }
    private var currentAnswers: [Int] = []
    private var correctAnswer: Int = 0
    private var isAnimating = false

    override func didMove(to view: SKView) {
        backgroundColor = UIColor(hex: "#08102a")
        DailyChallengeManager.shared.refreshIfNeeded()
        showCurrentState()
    }

    // MARK: - State Router

    private func showCurrentState() {
        removeAllChildren()
        isAnimating = false
        if DailyChallengeManager.shared.allCompleted {
            buildTopBar()
            buildAllCompletedScreen()
        } else {
            let challenges = DailyChallengeManager.shared.challenges
            if let idx = challenges.indices.first(where: { !challenges[$0].isCompleted }) {
                let done = challenges.filter { $0.isCompleted }.count
                buildTopBar()
                buildChallengeUI(challenge: challenges[idx], completedCount: done)
            }
        }
    }

    // MARK: - Top Bar

    private func buildTopBar() {
        let backBtn = SKShapeNode(rectOf: CGSize(width: 60, height: 28), cornerRadius: 8)
        backBtn.fillColor = UIColor(hex: "#131d3a")
        backBtn.strokeColor = UIColor(hex: "#2a3a6e")
        backBtn.lineWidth = 1
        backBtn.position = CGPoint(x: -W/2 + 40, y: H * 0.44)
        backBtn.name = "dc_back"
        addChild(backBtn)

        let backLabel = SKLabelNode(text: "← Hub")
        backLabel.fontName = "AvenirNext-Regular"
        backLabel.fontSize = 11
        backLabel.fontColor = UIColor(hex: "#aabbee")
        backLabel.verticalAlignmentMode = .center
        backLabel.position = CGPoint(x: -W/2 + 40, y: H * 0.44)
        backLabel.name = "dc_back"
        addChild(backLabel)

        let title = SKLabelNode(text: "Tages-Aufgaben")
        title.fontName = "AvenirNext-Bold"
        title.fontSize = min(W * 0.07, 28)
        title.fontColor = .white
        title.verticalAlignmentMode = .center
        title.position = CGPoint(x: 0, y: H * 0.44)
        addChild(title)

        let gemsLabel = SKLabelNode(text: "💎 \(ProgressManager.shared.gems)")
        gemsLabel.fontName = "AvenirNext-Bold"
        gemsLabel.fontSize = 14
        gemsLabel.fontColor = UIColor(hex: "#aa88ff")
        gemsLabel.horizontalAlignmentMode = .right
        gemsLabel.verticalAlignmentMode = .center
        gemsLabel.position = CGPoint(x: W/2 - 12, y: H * 0.44)
        addChild(gemsLabel)
    }

    // MARK: - Challenge UI

    private func buildChallengeUI(challenge: DailyChallenge, completedCount: Int) {
        let progress = SKLabelNode(text: "Aufgabe \(completedCount + 1) von 3")
        progress.fontName = "AvenirNext-Regular"
        progress.fontSize = 14
        progress.fontColor = UIColor(hex: "#8899cc")
        progress.verticalAlignmentMode = .center
        progress.position = CGPoint(x: 0, y: H * 0.34)
        addChild(progress)

        let rewardBadge = SKShapeNode(rectOf: CGSize(width: 80, height: 26), cornerRadius: 8)
        rewardBadge.fillColor = UIColor(hex: "#1a1040")
        rewardBadge.strokeColor = UIColor(hex: "#aa88ff")
        rewardBadge.lineWidth = 1
        rewardBadge.position = CGPoint(x: 0, y: H * 0.27)
        addChild(rewardBadge)

        let rewardLabel = SKLabelNode(text: "💎 +\(challenge.gemReward)")
        rewardLabel.fontName = "AvenirNext-Bold"
        rewardLabel.fontSize = 13
        rewardLabel.fontColor = UIColor(hex: "#aa88ff")
        rewardLabel.verticalAlignmentMode = .center
        rewardLabel.position = CGPoint(x: 0, y: H * 0.27)
        addChild(rewardLabel)

        let card = SKShapeNode(rectOf: CGSize(width: W - 40, height: 100), cornerRadius: 20)
        card.fillColor = UIColor(hex: "#1a2a5e")
        card.strokeColor = UIColor(hex: "#534AB7")
        card.lineWidth = 2
        card.position = CGPoint(x: 0, y: H * 0.12)
        addChild(card)

        let questionLabel = SKLabelNode(text: "\(challenge.multiplier) × \(challenge.factor) = ?")
        questionLabel.fontName = "AvenirNext-Bold"
        questionLabel.fontSize = min(W * 0.09, 36)
        questionLabel.fontColor = .white
        questionLabel.verticalAlignmentMode = .center
        questionLabel.position = CGPoint(x: 0, y: H * 0.12)
        addChild(questionLabel)

        correctAnswer = challenge.multiplier * challenge.factor
        currentAnswers = generateAnswerOptions(correct: correctAnswer)

        let btnW = W / 2 - 18
        let positions: [CGPoint] = [
            CGPoint(x: -W/4, y: -H * 0.06),
            CGPoint(x:  W/4, y: -H * 0.06),
            CGPoint(x: -W/4, y: -H * 0.17),
            CGPoint(x:  W/4, y: -H * 0.17),
        ]

        for i in 0..<4 {
            let btn = SKShapeNode(rectOf: CGSize(width: btnW, height: 58), cornerRadius: 15)
            btn.fillColor = UIColor(hex: "#534AB7")
            btn.strokeColor = UIColor(hex: "#7a70d4")
            btn.lineWidth = 2
            btn.position = positions[i]
            btn.name = "dc_answer_\(i)"
            addChild(btn)

            let lbl = SKLabelNode(text: "\(currentAnswers[i])")
            lbl.fontName = "AvenirNext-Bold"
            lbl.fontSize = 22
            lbl.fontColor = .white
            lbl.verticalAlignmentMode = .center
            lbl.position = positions[i]
            lbl.name = "dc_answer_label_\(i)"
            addChild(lbl)
        }
    }

    // MARK: - Completion Screens

    private func buildAllCompletedScreen() {
        let msg = SKLabelNode(text: "Heute schon geschafft! 🌟")
        msg.fontName = "AvenirNext-Bold"
        msg.fontSize = 22
        msg.fontColor = UIColor(hex: "#eedd88")
        msg.verticalAlignmentMode = .center
        msg.position = CGPoint(x: 0, y: H * 0.10)
        addChild(msg)

        let sub = SKLabelNode(text: "Komm morgen für neue Aufgaben!")
        sub.fontName = "AvenirNext-Regular"
        sub.fontSize = 14
        sub.fontColor = UIColor(hex: "#8899cc")
        sub.verticalAlignmentMode = .center
        sub.position = CGPoint(x: 0, y: H * 0.02)
        addChild(sub)

        addHubButton()
    }

    private func buildVictoryScreen() {
        removeAllChildren()
        buildTopBar()

        let total = DailyChallengeManager.shared.challenges.reduce(0) { $0 + $1.gemReward }

        let title = SKLabelNode(text: "Super! 🎉")
        title.fontName = "AvenirNext-Bold"
        title.fontSize = 36
        title.fontColor = .white
        title.verticalAlignmentMode = .center
        title.position = CGPoint(x: 0, y: H * 0.25)
        addChild(title)

        let sub = SKLabelNode(text: "Du hast alle Aufgaben gelöst!")
        sub.fontName = "AvenirNext-Regular"
        sub.fontSize = 16
        sub.fontColor = UIColor(hex: "#aabbee")
        sub.verticalAlignmentMode = .center
        sub.position = CGPoint(x: 0, y: H * 0.15)
        addChild(sub)

        let gems = SKLabelNode(text: "+\(total) 💎")
        gems.fontName = "AvenirNext-Bold"
        gems.fontSize = 32
        gems.fontColor = UIColor(hex: "#aa88ff")
        gems.verticalAlignmentMode = .center
        gems.position = CGPoint(x: 0, y: H * 0.04)
        addChild(gems)

        addHubButton()
    }

    private func addHubButton() {
        let btn = SKShapeNode(rectOf: CGSize(width: W - 48, height: 52), cornerRadius: 16)
        btn.fillColor = UIColor(hex: "#534AB7")
        btn.strokeColor = UIColor(hex: "#7a70d4")
        btn.lineWidth = 2
        btn.position = CGPoint(x: 0, y: -H * 0.15)
        btn.name = "dc_hub"
        addChild(btn)

        let lbl = SKLabelNode(text: "Zurück zum Hub")
        lbl.fontName = "AvenirNext-Bold"
        lbl.fontSize = 17
        lbl.fontColor = .white
        lbl.verticalAlignmentMode = .center
        lbl.position = .zero
        btn.addChild(lbl)
    }

    // MARK: - Answer Options

    private func generateAnswerOptions(correct: Int) -> [Int] {
        var options = Set<Int>()
        options.insert(correct)
        var attempts = 0
        while options.count < 4 && attempts < 100 {
            attempts += 1
            let offset = Int.random(in: -5...5)
            let candidate = correct + offset
            guard candidate > 0 && candidate != correct else { continue }
            options.insert(candidate)
        }
        var fallback = 1
        while options.count < 4 {
            if !options.contains(fallback) { options.insert(fallback) }
            fallback += 1
        }
        return options.shuffled()
    }

    // MARK: - Touch

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard !isAnimating, let touch = touches.first else { return }
        let node = atPoint(touch.location(in: self))

        var name = node.name ?? ""
        if name.hasPrefix("dc_answer_label_") {
            name = "dc_answer_" + name.replacingOccurrences(of: "dc_answer_label_", with: "")
        }
        if node.parent?.name == "dc_hub" || name == "dc_hub" {
            navigateToHub(); return
        }

        switch name {
        case "dc_back":
            navigateToHub()
        default:
            if name.hasPrefix("dc_answer_") {
                let idx = Int(name.replacingOccurrences(of: "dc_answer_", with: "")) ?? -1
                if idx >= 0 && idx < currentAnswers.count {
                    handleAnswer(buttonIndex: idx)
                }
            }
        }
    }

    // MARK: - Game Logic

    private func handleAnswer(buttonIndex: Int) {
        isAnimating = true
        let isCorrect = currentAnswers[buttonIndex] == correctAnswer
        guard let btn = childNode(withName: "dc_answer_\(buttonIndex)") as? SKShapeNode else {
            isAnimating = false; return
        }

        btn.fillColor = isCorrect ? UIColor(hex: "#0F6E56") : UIColor(hex: "#C0392B")

        if isCorrect {
            SoundManager.shared.playSFX(SoundName.correct)
            let challenges = DailyChallengeManager.shared.challenges
            if let idx = challenges.indices.first(where: { !challenges[$0].isCompleted }) {
                DailyChallengeManager.shared.markCompleted(index: idx)
            }
            run(SKAction.sequence([.wait(forDuration: 0.4), .run { [weak self] in
                self?.isAnimating = false
                if DailyChallengeManager.shared.allCompleted {
                    self?.buildVictoryScreen()
                } else {
                    self?.showCurrentState()
                }
            }]))
        } else {
            SoundManager.shared.playSFX(SoundName.wrong)
            run(SKAction.sequence([.wait(forDuration: 0.3), .run { [weak self] in
                btn.fillColor = UIColor(hex: "#534AB7")
                self?.isAnimating = false
            }]))
        }
    }

    private func navigateToHub() {
        let hub = HubScene(size: size)
        hub.scaleMode = .aspectFill
        hub.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        view?.presentScene(hub, transition: SKTransition.fade(withDuration: 0.4))
    }
}
