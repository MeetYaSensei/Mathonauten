import SpriteKit

enum AppScene {
    case hub
    case menu
    case map
    case battle(planetID: String)
    case reward(planetID: String)
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
        case .battle(let planetID):
            scene = BattleScene(size: size, planetID: planetID)
        case .reward(let planetID):
            scene = RewardScene(size: size, planetID: planetID)
        }

        scene.scaleMode = .aspectFill
        scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        view.presentScene(scene, transition: transition)
    }
}
