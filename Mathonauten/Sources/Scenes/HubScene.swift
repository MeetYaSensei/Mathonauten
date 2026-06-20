import SpriteKit

class HubScene: SKScene {

    private var W: CGFloat { size.width }
    private var H: CGFloat { size.height }

    private var progressBarFill: SKShapeNode!
    private var progressLabel: SKLabelNode!
    private var levelLabel: SKLabelNode!
    private var starsLabel: SKLabelNode!
    private var gemsLabel: SKLabelNode!

    override func didMove(to view: SKView) {
        setupBackground()
        setupStars()
        setupTopBar()
        setupNavTabs()
        setupRobo()
        setupPlayButton()
        setupProgressBanner()
        setupDailyChallenges()
        setupBottomNav()
        DailyChallengeManager.shared.refreshIfNeeded()
        refreshUI()
        SoundManager.shared.playBGM(SoundName.bgmHub)
    }

    // MARK: - Refresh

    func refreshUI() {
        let pm = ProgressManager.shared
        progressBarFill?.xScale = max(CGFloat(pm.planetProgress), 0.02)
        progressLabel?.text = pm.hubProgressText
        levelLabel?.text = pm.hubLevelText
        starsLabel?.text = "⭐ \(pm.stars)"
        gemsLabel?.text = "💎 \(pm.gems)"
    }

    // MARK: - Background

    private func setupBackground() {
        let bg = SKSpriteNode(color: UIColor(hex: "#0a0f1e"), size: size)
        bg.position = .zero
        bg.zPosition = -10
        addChild(bg)
    }

    private func setupStars() {
        for _ in 0..<60 {
            let r = CGFloat.random(in: 1.0...2.0)
            let star = SKShapeNode(circleOfRadius: r)
            star.fillColor = .white
            star.strokeColor = .clear
            star.alpha = CGFloat.random(in: 0.2...0.6)
            star.position = CGPoint(x: CGFloat.random(in: -W/2...W/2),
                                    y: CGFloat.random(in: -H/2...H/2))
            star.zPosition = -9
            addChild(star)
        }
    }

    // MARK: - Top Bar

    private func setupTopBar() {
        let y = H * 0.44

        let avatar = SKShapeNode(circleOfRadius: 18)
        avatar.fillColor = UIColor(hex: "#1a2a5e")
        avatar.strokeColor = UIColor(hex: "#534AB7")
        avatar.lineWidth = 2
        avatar.position = CGPoint(x: -W * 0.35, y: y)
        addChild(avatar)

        let avatarLabel = SKLabelNode(text: "🧑")
        avatarLabel.fontSize = 18
        avatarLabel.verticalAlignmentMode = .center
        avatarLabel.position = CGPoint(x: -W * 0.35, y: y)
        addChild(avatarLabel)

        let nameLabel = SKLabelNode(text: "Spieler")
        nameLabel.fontName = "AvenirNext-Regular"
        nameLabel.fontSize = 12
        nameLabel.fontColor = UIColor(hex: "#aabbee")
        nameLabel.horizontalAlignmentMode = .left
        nameLabel.verticalAlignmentMode = .center
        nameLabel.position = CGPoint(x: -W * 0.22, y: y + 6)
        addChild(nameLabel)

        let lvBadge = SKShapeNode(rectOf: CGSize(width: 80, height: 16), cornerRadius: 4)
        lvBadge.fillColor = UIColor(hex: "#534AB7")
        lvBadge.strokeColor = .clear
        lvBadge.position = CGPoint(x: -W * 0.15, y: y - 9)
        addChild(lvBadge)

        let lvLabel = SKLabelNode(text: "Lv. 3 Raumfahrer")
        lvLabel.fontName = "AvenirNext-Regular"
        lvLabel.fontSize = 8
        lvLabel.fontColor = UIColor(hex: "#ccd0ff")
        lvLabel.verticalAlignmentMode = .center
        lvLabel.position = CGPoint(x: -W * 0.15, y: y - 9)
        addChild(lvLabel)

        let starsBg = SKShapeNode(rectOf: CGSize(width: 60, height: 22), cornerRadius: 6)
        starsBg.fillColor = UIColor(hex: "#131d3a")
        starsBg.strokeColor = UIColor(hex: "#2a3a6e")
        starsBg.lineWidth = 1
        starsBg.position = CGPoint(x: W * 0.18, y: y)
        addChild(starsBg)

        starsLabel = SKLabelNode(text: "⭐ 0")
        starsLabel.fontName = "AvenirNext-Regular"
        starsLabel.fontSize = 10
        starsLabel.fontColor = UIColor(hex: "#eedd88")
        starsLabel.verticalAlignmentMode = .center
        starsLabel.position = CGPoint(x: W * 0.18, y: y)
        addChild(starsLabel)

        let gemsBg = SKShapeNode(rectOf: CGSize(width: 55, height: 22), cornerRadius: 6)
        gemsBg.fillColor = UIColor(hex: "#131d3a")
        gemsBg.strokeColor = UIColor(hex: "#2a3a6e")
        gemsBg.lineWidth = 1
        gemsBg.position = CGPoint(x: W * 0.32, y: y)
        addChild(gemsBg)

        gemsLabel = SKLabelNode(text: "💎 0")
        gemsLabel.fontName = "AvenirNext-Regular"
        gemsLabel.fontSize = 10
        gemsLabel.fontColor = UIColor(hex: "#aa88ff")
        gemsLabel.verticalAlignmentMode = .center
        gemsLabel.position = CGPoint(x: W * 0.32, y: y)
        addChild(gemsLabel)

        let settings = SKShapeNode(rectOf: CGSize(width: 28, height: 28), cornerRadius: 6)
        settings.fillColor = UIColor(hex: "#131d3a")
        settings.strokeColor = UIColor(hex: "#2a3a6e")
        settings.lineWidth = 1
        settings.position = CGPoint(x: W * 0.44, y: y)
        settings.name = "btn_settings"
        addChild(settings)

        let gear = SKLabelNode(text: "⚙")
        gear.fontSize = 14
        gear.verticalAlignmentMode = .center
        gear.position = CGPoint(x: W * 0.44, y: y)
        addChild(gear)
    }

    // MARK: - Nav Tabs

    private func setupNavTabs() {
        let y = H * 0.38
        let tabW = W / 5 - 8
        let tabs: [(String, String, String)] = [
            ("🏠", "Hub",     "tab_hub"),
            ("🗺", "Karte",   "tab_map"),
            ("🏆", "Erfolge", "tab_achievements"),
            ("🎒", "Items",   "tab_items"),
            ("📊", "Stats",   "tab_stats"),
        ]
        let xs: [CGFloat] = [-2*W/5, -W/5, 0, W/5, 2*W/5]

        for (i, tab) in tabs.enumerated() {
            let isActive = i == 0
            let bg = SKShapeNode(rectOf: CGSize(width: tabW, height: 38), cornerRadius: 8)
            bg.fillColor = isActive ? UIColor(hex: "#534AB7") : UIColor(hex: "#131d3a")
            bg.strokeColor = isActive ? UIColor(hex: "#7a70d4") : UIColor(hex: "#2a3a6e")
            bg.lineWidth = 1
            bg.position = CGPoint(x: xs[i], y: y)
            bg.name = tab.2
            addChild(bg)

            let icon = SKLabelNode(text: tab.0)
            icon.fontSize = 14
            icon.verticalAlignmentMode = .center
            icon.position = CGPoint(x: xs[i], y: y + 7)
            icon.name = tab.2
            addChild(icon)

            let lbl = SKLabelNode(text: tab.1)
            lbl.fontName = "AvenirNext-Regular"
            lbl.fontSize = 7
            lbl.fontColor = isActive ? .white : UIColor(hex: "#8899cc")
            lbl.verticalAlignmentMode = .center
            lbl.position = CGPoint(x: xs[i], y: y - 9)
            lbl.name = tab.2
            addChild(lbl)
        }
    }

    // MARK: - Robo

    private func setupRobo() {
        let by = H * 0.10

        let body = SKShapeNode(rectOf: CGSize(width: 60, height: 70), cornerRadius: 14)
        body.fillColor = UIColor(hex: "#1a2a5e")
        body.strokeColor = UIColor(hex: "#534AB7")
        body.lineWidth = 2
        body.position = CGPoint(x: 0, y: by)
        addChild(body)

        let head = SKShapeNode(rectOf: CGSize(width: 50, height: 40), cornerRadius: 10)
        head.fillColor = UIColor(hex: "#1a2a5e")
        head.strokeColor = UIColor(hex: "#534AB7")
        head.lineWidth = 2
        head.position = CGPoint(x: 0, y: by + 56)
        addChild(head)

        for xOff: CGFloat in [-12, 12] {
            let eye = SKShapeNode(rectOf: CGSize(width: 10, height: 12), cornerRadius: 3)
            eye.fillColor = UIColor(hex: "#534AB7")
            eye.strokeColor = UIColor(hex: "#7a70d4")
            eye.lineWidth = 1
            eye.position = CGPoint(x: xOff, y: by + 60)
            addChild(eye)
        }

        let antBase = SKShapeNode(rectOf: CGSize(width: 3, height: 12))
        antBase.fillColor = UIColor(hex: "#534AB7")
        antBase.strokeColor = .clear
        antBase.position = CGPoint(x: 0, y: by + 83)
        addChild(antBase)

        let antBall = SKShapeNode(circleOfRadius: 4)
        antBall.fillColor = UIColor(hex: "#7a70d4")
        antBall.strokeColor = .clear
        antBall.position = CGPoint(x: 0, y: by + 92)
        addChild(antBall)

        let emblem = SKShapeNode(rectOf: CGSize(width: 24, height: 24), cornerRadius: 6)
        emblem.fillColor = UIColor(hex: "#0F6E56")
        emblem.strokeColor = UIColor(hex: "#1d9e75")
        emblem.lineWidth = 1
        emblem.position = CGPoint(x: 0, y: by)
        addChild(emblem)

        let emblemIcon = SKLabelNode(text: "⚡")
        emblemIcon.fontSize = 12
        emblemIcon.verticalAlignmentMode = .center
        emblemIcon.position = CGPoint(x: 0, y: by)
        addChild(emblemIcon)

        let bubbleW: CGFloat = 90
        let bubbleX: CGFloat = 65 + bubbleW / 2
        let bubbleY = by + 56

        let bubble = SKShapeNode(rectOf: CGSize(width: bubbleW, height: 24), cornerRadius: 8)
        bubble.fillColor = UIColor(hex: "#1a2a5e")
        bubble.strokeColor = UIColor(hex: "#534AB7")
        bubble.lineWidth = 1.5
        bubble.position = CGPoint(x: bubbleX, y: bubbleY)
        addChild(bubble)

        let trianglePath = CGMutablePath()
        trianglePath.move(to: CGPoint(x: bubbleX - bubbleW/2, y: bubbleY))
        trianglePath.addLine(to: CGPoint(x: bubbleX - bubbleW/2 - 8, y: bubbleY + 5))
        trianglePath.addLine(to: CGPoint(x: bubbleX - bubbleW/2 - 8, y: bubbleY - 5))
        trianglePath.closeSubpath()
        let triangle = SKShapeNode(path: trianglePath)
        triangle.fillColor = UIColor(hex: "#534AB7")
        triangle.strokeColor = .clear
        addChild(triangle)

        let speechLabel = SKLabelNode(text: "Bereit für Mathe? 🚀")
        speechLabel.fontName = "AvenirNext-Regular"
        speechLabel.fontSize = 9
        speechLabel.fontColor = UIColor(hex: "#aabbee")
        speechLabel.verticalAlignmentMode = .center
        speechLabel.position = CGPoint(x: bubbleX, y: bubbleY)
        addChild(speechLabel)
    }

    // MARK: - Play Button

    private func setupPlayButton() {
        let y = -H * 0.13
        let btnW = W - 28

        let btn = SKShapeNode(rectOf: CGSize(width: btnW, height: 52), cornerRadius: 16)
        btn.fillColor = UIColor(hex: "#0F6E56")
        btn.strokeColor = UIColor(hex: "#1d9e75")
        btn.lineWidth = 2
        btn.position = CGPoint(x: 0, y: y)
        btn.name = "playBtn"
        addChild(btn)

        let circle = SKShapeNode(circleOfRadius: 14)
        circle.fillColor = UIColor(hex: "#1d9e75")
        circle.strokeColor = .clear
        circle.position = CGPoint(x: -btnW/2 + 26, y: y)
        circle.name = "playBtn"
        addChild(circle)

        let playIcon = SKLabelNode(text: "▶")
        playIcon.fontSize = 12
        playIcon.fontColor = .white
        playIcon.verticalAlignmentMode = .center
        playIcon.position = CGPoint(x: -btnW/2 + 27, y: y)
        playIcon.name = "playBtn"
        addChild(playIcon)

        let playLabel = SKLabelNode(text: "SPIELEN!")
        playLabel.fontName = "AvenirNext-Bold"
        playLabel.fontSize = 18
        playLabel.fontColor = UIColor(hex: "#9fe1cb")
        playLabel.verticalAlignmentMode = .center
        playLabel.position = CGPoint(x: 16, y: y)
        playLabel.name = "playBtn"
        addChild(playLabel)
    }

    // MARK: - Progress Banner

    private func setupProgressBanner() {
        let y = -H * 0.22
        let pm = ProgressManager.shared

        let banner = SKShapeNode(rectOf: CGSize(width: W - 28, height: 44), cornerRadius: 10)
        banner.fillColor = UIColor(hex: "#131d3a")
        banner.strokeColor = UIColor(hex: "#2a3a6e")
        banner.lineWidth = 1
        banner.position = CGPoint(x: 0, y: y)
        addChild(banner)

        progressLabel = SKLabelNode(text: pm.hubProgressText)
        progressLabel.fontName = "AvenirNext-Regular"
        progressLabel.fontSize = 10
        progressLabel.fontColor = UIColor(hex: "#8899cc")
        progressLabel.horizontalAlignmentMode = .left
        progressLabel.verticalAlignmentMode = .center
        progressLabel.position = CGPoint(x: -(W-28)/2 + 12, y: y + 7)
        addChild(progressLabel)

        levelLabel = SKLabelNode(text: pm.hubLevelText)
        levelLabel.fontName = "AvenirNext-Regular"
        levelLabel.fontSize = 10
        levelLabel.fontColor = UIColor(hex: "#aabbee")
        levelLabel.horizontalAlignmentMode = .right
        levelLabel.verticalAlignmentMode = .center
        levelLabel.position = CGPoint(x: (W-28)/2 - 12, y: y + 7)
        addChild(levelLabel)

        let barW = W - 56
        let barY = y - 10

        let barBg = SKShapeNode(rectOf: CGSize(width: barW, height: 7), cornerRadius: 3)
        barBg.fillColor = UIColor(hex: "#1a2a5e")
        barBg.strokeColor = .clear
        barBg.position = CGPoint(x: 0, y: barY)
        addChild(barBg)

        progressBarFill = SKShapeNode(rectOf: CGSize(width: barW, height: 7), cornerRadius: 3)
        progressBarFill.fillColor = UIColor(hex: "#534AB7")
        progressBarFill.strokeColor = .clear
        progressBarFill.position = CGPoint(x: 0, y: barY)
        addChild(progressBarFill)
    }

    // MARK: - Daily Challenges

    private func setupDailyChallenges() {
        let headerY = -H * 0.28

        let headerLabel = SKLabelNode(text: "Tägliche Aufgaben")
        headerLabel.fontName = "AvenirNext-Bold"
        headerLabel.fontSize = 12
        headerLabel.fontColor = UIColor(hex: "#ccddff")
        headerLabel.horizontalAlignmentMode = .left
        headerLabel.verticalAlignmentMode = .center
        headerLabel.position = CGPoint(x: -W/2 + 16, y: headerY)
        addChild(headerLabel)

        let allLabel = SKLabelNode(text: "Alle →")
        allLabel.fontName = "AvenirNext-Regular"
        allLabel.fontSize = 11
        allLabel.fontColor = UIColor(hex: "#7a70d4")
        allLabel.horizontalAlignmentMode = .right
        allLabel.verticalAlignmentMode = .center
        allLabel.position = CGPoint(x: W/2 - 16, y: headerY)
        allLabel.name = "dc_card_any"
        addChild(allLabel)

        let challenges = DailyChallengeManager.shared.challenges
        let icons = ["🌱", "🔥", "⭐"]
        let cardY = -H * 0.34
        let cardW = W / 3 - 12
        let cardXs: [CGFloat] = [-W * 0.31, 0, W * 0.31]

        for (i, c) in challenges.enumerated() {
            let cx = cardXs[i]
            let done = c.isCompleted

            let cardBg = SKShapeNode(rectOf: CGSize(width: cardW, height: 70), cornerRadius: 12)
            cardBg.fillColor = UIColor(hex: done ? "#0d1a10" : "#131d3a")
            cardBg.strokeColor = UIColor(hex: done ? "#1d9e75" : "#2a3a6e")
            cardBg.lineWidth = 1
            cardBg.position = CGPoint(x: cx, y: cardY)
            cardBg.alpha = done ? 0.65 : 1.0
            cardBg.name = "dc_card_\(i)"
            addChild(cardBg)

            let iconLabel = SKLabelNode(text: done ? "✅" : icons[i])
            iconLabel.fontSize = 15
            iconLabel.verticalAlignmentMode = .center
            iconLabel.position = CGPoint(x: cx, y: cardY + 22)
            iconLabel.name = "dc_card_\(i)"
            addChild(iconLabel)

            let questionLabel = SKLabelNode(text: "\(c.multiplier) × \(c.factor) = ?")
            questionLabel.fontName = "AvenirNext-Bold"
            questionLabel.fontSize = 10
            questionLabel.fontColor = UIColor(hex: done ? "#5a9e75" : "#ccd8ff")
            questionLabel.verticalAlignmentMode = .center
            questionLabel.position = CGPoint(x: cx, y: cardY + 6)
            questionLabel.name = "dc_card_\(i)"
            addChild(questionLabel)

            let rewardLabel = SKLabelNode(text: "💎 +\(c.gemReward)")
            rewardLabel.fontName = "AvenirNext-Bold"
            rewardLabel.fontSize = 9
            rewardLabel.fontColor = UIColor(hex: "#aa88ff")
            rewardLabel.verticalAlignmentMode = .center
            rewardLabel.position = CGPoint(x: cx, y: cardY - 8)
            rewardLabel.name = "dc_card_\(i)"
            addChild(rewardLabel)

            let miniBarW = cardW - 16
            let miniBarY = cardY - 22

            let miniBarBg = SKShapeNode(rectOf: CGSize(width: miniBarW, height: 4), cornerRadius: 2)
            miniBarBg.fillColor = UIColor(hex: "#1a2a5e")
            miniBarBg.strokeColor = .clear
            miniBarBg.position = CGPoint(x: cx, y: miniBarY)
            addChild(miniBarBg)

            if done {
                let fill = SKShapeNode(rectOf: CGSize(width: miniBarW, height: 4), cornerRadius: 2)
                fill.fillColor = UIColor(hex: "#1d9e75")
                fill.strokeColor = .clear
                fill.position = CGPoint(x: cx, y: miniBarY)
                addChild(fill)
            }
        }
    }

    // MARK: - Bottom Nav

    private func setupBottomNav() {
        let y = -H * 0.46

        let navBg = SKShapeNode(rectOf: CGSize(width: W, height: 56))
        navBg.fillColor = UIColor(hex: "#0d1630")
        navBg.strokeColor = UIColor(hex: "#1e2d5a")
        navBg.lineWidth = 1
        navBg.position = CGPoint(x: 0, y: y)
        addChild(navBg)

        let items: [(String, String, String, Bool)] = [
            ("🏠", "Hub",    "bottom_hub",     true),
            ("🗺", "Karte",  "bottom_map",     false),
            ("🏆", "Rang",   "bottom_rank",    false),
            ("👤", "Profil", "bottom_profile", false),
        ]
        let xs: [CGFloat] = [-3*W/8, -W/8, W/8, 3*W/8]

        for (i, item) in items.enumerated() {
            let color: UIColor = item.3 ? UIColor(hex: "#7a70d4") : UIColor(hex: "#5a6a99")

            let icon = SKLabelNode(text: item.0)
            icon.fontSize = 20
            icon.fontColor = color
            icon.verticalAlignmentMode = .center
            icon.position = CGPoint(x: xs[i], y: y + 10)
            icon.name = item.2
            addChild(icon)

            let lbl = SKLabelNode(text: item.1)
            lbl.fontName = "AvenirNext-Regular"
            lbl.fontSize = 8
            lbl.fontColor = color
            lbl.verticalAlignmentMode = .center
            lbl.position = CGPoint(x: xs[i], y: y - 10)
            lbl.name = item.2
            addChild(lbl)
        }
    }

    // MARK: - Touch

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)

        for node in nodes(at: location) {
            guard let name = node.name else { continue }
            switch name {
            case "tab_map", "bottom_map":
                SoundManager.shared.playSFX(SoundName.tap)
                guard let view = view else { return }
                SceneManager.transition(to: .map, from: view)
                return
            case let n where n.hasPrefix("dc_card_"):
                SoundManager.shared.playSFX(SoundName.tap)
                DailyChallengeManager.shared.refreshIfNeeded()
                let dcScene = DailyChallengeScene(size: size)
                dcScene.scaleMode = .aspectFill
                dcScene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                view?.presentScene(dcScene, transition: SKTransition.fade(withDuration: 0.4))
                return
            case "playBtn":
                SoundManager.shared.playSFX(SoundName.tap)
                let battle = BattleScene(size: size)
                battle.scaleMode = .aspectFill
                battle.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                view?.presentScene(battle, transition: SKTransition.push(with: .left, duration: 0.4))
                return
            case "tab_hub", "bottom_hub":
                return
            default:
                break
            }
        }
    }
}
