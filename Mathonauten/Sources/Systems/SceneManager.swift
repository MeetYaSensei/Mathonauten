import SpriteKit

enum AppScene {
    case hub
    case menu
    case map
    case battle(planetIndex: Int)
}

final class SceneManager {

    static func transition(to destination: AppScene, from view: SKView) {
        let transition = SKTransition.fade(withDuration: 0.4)
        let size = view.bounds.size
        let scene: SKScene

        switch destination {
        case .hub:
            scene = HubScene(size: size)
        case .menu:
            scene = MenuScene(size: size)
        case .map:
            scene = MapScene(size: size)
        case .battle(let idx):
            scene = BattleScene(size: size, planetIndex: idx)
        }

        scene.scaleMode = .aspectFill
        scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        view.presentScene(scene, transition: transition)
    }
}
