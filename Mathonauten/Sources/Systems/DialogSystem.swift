import SpriteKit

/// Einfaches Dialog-System für Robo-Hinweise & Story-Dialoge
struct DialogLine {
    let speaker: String   // z.B. "Robo", "Leo"
    let text: String
}

class DialogNode: SKNode {

    private let background: SKShapeNode
    private let speakerLabel: SKLabelNode
    private let textLabel: SKLabelNode
    private var lines: [DialogLine] = []
    private var currentIndex = 0
    var onFinished: (() -> Void)?

    init(size: CGSize) {
        let w = size.width * 0.8
        let h: CGFloat = 120
        background = SKShapeNode(rectOf: CGSize(width: w, height: h), cornerRadius: 16)
        background.fillColor = UIColor(white: 0.1, alpha: 0.9)
        background.strokeColor = .cyan
        background.lineWidth = 2

        speakerLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        speakerLabel.fontSize = 18
        speakerLabel.fontColor = .cyan
        speakerLabel.position = CGPoint(x: -w/2 + 20, y: h/2 - 28)
        speakerLabel.horizontalAlignmentMode = .left

        textLabel = SKLabelNode(fontNamed: "AvenirNext-Regular")
        textLabel.fontSize = 16
        textLabel.fontColor = .white
        textLabel.position = CGPoint(x: 0, y: -10)
        textLabel.numberOfLines = 3
        textLabel.preferredMaxLayoutWidth = w - 40
        textLabel.horizontalAlignmentMode = .center

        super.init()
        addChild(background)
        addChild(speakerLabel)
        addChild(textLabel)
        isUserInteractionEnabled = false
    }

    required init?(coder: NSCoder) { fatalError() }

    func show(lines: [DialogLine], onFinished: (() -> Void)? = nil) {
        self.lines = lines
        self.currentIndex = 0
        self.onFinished = onFinished
        isHidden = false
        showCurrent()
    }

    func advance() {
        currentIndex += 1
        if currentIndex < lines.count {
            showCurrent()
        } else {
            isHidden = true
            onFinished?()
        }
    }

    private func showCurrent() {
        let line = lines[currentIndex]
        speakerLabel.text = line.speaker
        textLabel.text = line.text
    }
}
