import SpriteKit
import UIKit

class ShopScene: SKScene {

    private var W: CGFloat { size.width }
    private var H: CGFloat { size.height }

    private var currentCategory: ShopCategory = .powerup
    private var cardContainer: SKNode!
    private var gemsLabel: SKLabelNode!

    private let categoryOrder: [ShopCategory] = [.powerup, .roboSkin, .alienSkin, .planetTheme]
    private let categoryLabel: [ShopCategory: String] = [
        .powerup: "Power-ups",
        .roboSkin: "Robo",
        .alienSkin: "Aliens",
        .planetTheme: "Themes"
    ]

    override func didMove(to view: SKView) {
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        backgroundColor = UIColor(hex: "#08102a")
        setupTopBar()
        setupCategoryTabs()
        setupBackButton()
        cardContainer = SKNode()
        addChild(cardContainer)
        refreshCards()
    }

    // MARK: - Static UI

    private func setupTopBar() {
        let title = SKLabelNode(text: "🛒 Shop")
        title.fontName = "AvenirNext-Bold"
        title.fontSize = 26
        title.fontColor = .white
        title.verticalAlignmentMode = .center
        title.position = CGPoint(x: -W * 0.1, y: H * 0.43)
        addChild(title)

        let gemsBg = SKShapeNode(rectOf: CGSize(width: 80, height: 28), cornerRadius: 8)
        gemsBg.fillColor = UIColor(hex: "#131d3a")
        gemsBg.strokeColor = UIColor(hex: "#0F6E56")
        gemsBg.lineWidth = 1.5
        gemsBg.position = CGPoint(x: W * 0.35, y: H * 0.43)
        addChild(gemsBg)

        gemsLabel = SKLabelNode(text: "💎 \(ProgressManager.shared.gems)")
        gemsLabel.fontName = "AvenirNext-Bold"
        gemsLabel.fontSize = 13
        gemsLabel.fontColor = UIColor(hex: "#1d9e75")
        gemsLabel.verticalAlignmentMode = .center
        gemsLabel.position = CGPoint(x: W * 0.35, y: H * 0.43)
        addChild(gemsLabel)
    }

    private func setupCategoryTabs() {
        let tabY = H * 0.34
        let tabW = W / 4 - 8
        let tabH: CGFloat = 32
        let positions: [CGFloat] = [-W * 0.375, -W * 0.125, W * 0.125, W * 0.375]

        for (i, cat) in categoryOrder.enumerated() {
            let active = cat == currentCategory
            let bg = SKShapeNode(rectOf: CGSize(width: tabW, height: tabH), cornerRadius: 8)
            bg.fillColor = active ? UIColor(hex: "#534AB7") : UIColor(hex: "#131d3a")
            bg.strokeColor = active ? UIColor(hex: "#7a70d4") : UIColor(hex: "#2a3a6e")
            bg.lineWidth = 1
            bg.position = CGPoint(x: positions[i], y: tabY)
            bg.name = "tab_\(cat.rawValue)"
            addChild(bg)

            let lbl = SKLabelNode(text: categoryLabel[cat] ?? cat.rawValue)
            lbl.fontName = active ? "AvenirNext-Bold" : "AvenirNext-Regular"
            lbl.fontSize = 10
            lbl.fontColor = .white
            lbl.verticalAlignmentMode = .center
            lbl.position = CGPoint(x: positions[i], y: tabY)
            lbl.name = "tab_\(cat.rawValue)"
            addChild(lbl)
        }
    }

    private func setupBackButton() {
        let btn = SKShapeNode(rectOf: CGSize(width: 80, height: 30), cornerRadius: 8)
        btn.fillColor = UIColor(hex: "#131d3a")
        btn.strokeColor = UIColor(hex: "#2a3a6e")
        btn.lineWidth = 1
        btn.position = CGPoint(x: -W * 0.35, y: -H * 0.44)
        btn.name = "back_btn"
        addChild(btn)

        let lbl = SKLabelNode(text: "← Zurück")
        lbl.fontName = "AvenirNext-Regular"
        lbl.fontSize = 12
        lbl.fontColor = UIColor(hex: "#aabbee")
        lbl.verticalAlignmentMode = .center
        lbl.position = CGPoint(x: -W * 0.35, y: -H * 0.44)
        lbl.name = "back_btn"
        addChild(lbl)
    }

    // MARK: - Card Grid

    private func refreshCards() {
        cardContainer.removeAllChildren()

        let items = ShopManager.shared.items(in: currentCategory)
        let cardW = W * 0.46
        let cardH: CGFloat = 92
        let colXs: [CGFloat] = [-W * 0.245, W * 0.245]
        let startY = H * 0.22
        let rowGap: CGFloat = cardH + 10

        for (i, item) in items.enumerated() {
            let col = i % 2
            let row = i / 2
            buildCard(item: item,
                      cx: colXs[col],
                      cy: startY - CGFloat(row) * rowGap,
                      cardW: cardW, cardH: cardH)
        }
    }

    private func buildCard(item: ShopItem, cx: CGFloat, cy: CGFloat, cardW: CGFloat, cardH: CGFloat) {
        let bg = SKShapeNode(rectOf: CGSize(width: cardW, height: cardH), cornerRadius: 12)
        bg.fillColor = UIColor(hex: "#131d3a")
        bg.strokeColor = item.isEquipped ? UIColor(hex: "#1d9e75") : UIColor(hex: "#2a3a6e")
        bg.lineWidth = item.isEquipped ? 2 : 1
        bg.position = CGPoint(x: cx, y: cy)
        bg.name = "card_shape_\(item.id)"
        cardContainer.addChild(bg)

        let nameL = SKLabelNode(text: item.name)
        nameL.fontName = "AvenirNext-Bold"
        nameL.fontSize = 11
        nameL.fontColor = .white
        nameL.verticalAlignmentMode = .center
        nameL.position = CGPoint(x: cx, y: cy + 30)
        cardContainer.addChild(nameL)

        let descL = SKLabelNode(text: item.description)
        descL.fontName = "AvenirNext-Regular"
        descL.fontSize = 8.5
        descL.fontColor = UIColor(hex: "#8899cc")
        descL.verticalAlignmentMode = .center
        descL.position = CGPoint(x: cx, y: cy + 14)
        cardContainer.addChild(descL)

        let priceText: String
        if item.category == .powerup {
            let n = ShopManager.shared.powerupCount(for: item.id)
            priceText = "Besitz: \(n)x  ·  💎\(item.price) / +3"
        } else {
            priceText = "💎 \(item.price)"
        }
        let priceL = SKLabelNode(text: priceText)
        priceL.fontName = "AvenirNext-Regular"
        priceL.fontSize = 9
        priceL.fontColor = UIColor(hex: "#0F6E56")
        priceL.verticalAlignmentMode = .center
        priceL.position = CGPoint(x: cx, y: cy + 0)
        cardContainer.addChild(priceL)

        // Action button
        let btnW = cardW - 18
        let btnH: CGFloat = 24
        let btnY = cy - 28

        let (btnText, btnColor): (String, UIColor)
        if item.category == .powerup {
            btnText = "Kaufen +3"
            btnColor = UIColor(hex: "#534AB7")
        } else if item.isPurchased {
            if item.isEquipped {
                btnText = "Ausgerüstet ✓"
                btnColor = UIColor(hex: "#0F6E56")
            } else {
                btnText = "Ausrüsten"
                btnColor = UIColor(hex: "#1a5a8a")
            }
        } else {
            btnText = "Kaufen"
            btnColor = UIColor(hex: "#534AB7")
        }

        let btnBg = SKShapeNode(rectOf: CGSize(width: btnW, height: btnH), cornerRadius: 6)
        btnBg.fillColor = btnColor
        btnBg.strokeColor = .clear
        btnBg.position = CGPoint(x: cx, y: btnY)
        btnBg.name = "card_btn_\(item.id)"
        cardContainer.addChild(btnBg)

        let btnL = SKLabelNode(text: btnText)
        btnL.fontName = "AvenirNext-Bold"
        btnL.fontSize = 9
        btnL.fontColor = .white
        btnL.verticalAlignmentMode = .center
        btnL.position = CGPoint(x: cx, y: btnY)
        btnL.name = "card_btn_\(item.id)"
        cardContainer.addChild(btnL)
    }

    // MARK: - Touch

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let node = atPoint(touch.location(in: self))
        let name = node.name ?? ""

        if name == "back_btn" {
            let hub = HubScene(size: size)
            hub.scaleMode = .aspectFill
            hub.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            view?.presentScene(hub, transition: SKTransition.fade(withDuration: 0.4))
            return
        }

        for cat in categoryOrder where name == "tab_\(cat.rawValue)" {
            guard cat != currentCategory else { return }
            currentCategory = cat
            children.filter { $0.name?.hasPrefix("tab_") == true }.forEach { $0.removeFromParent() }
            setupCategoryTabs()
            refreshCards()
            return
        }

        if name.hasPrefix("card_btn_") {
            let id = String(name.dropFirst("card_btn_".count))
            handleCardAction(itemId: id)
        }
    }

    private func handleCardAction(itemId: String) {
        guard let item = ShopManager.shared.items.first(where: { $0.id == itemId }) else { return }

        if item.isPurchased && item.category != .powerup {
            ShopManager.shared.equip(itemId: itemId)
            refreshCards()
            return
        }

        if ShopManager.shared.purchase(itemId: itemId) {
            gemsLabel.text = "💎 \(ProgressManager.shared.gems)"
            refreshCards()
        } else {
            flashRed(itemId: itemId)
        }
    }

    private func flashRed(itemId: String) {
        guard let btn = cardContainer.children
            .compactMap({ $0 as? SKShapeNode })
            .first(where: { $0.name == "card_btn_\(itemId)" })
        else { return }

        let orig = btn.fillColor
        btn.fillColor = UIColor(hex: "#C0392B")
        btn.run(.sequence([
            .wait(forDuration: 0.5),
            .run { btn.fillColor = orig }
        ]))
    }
}
