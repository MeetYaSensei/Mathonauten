import AVFoundation
import SpriteKit

final class SoundManager {

    static let shared = SoundManager()
    private init() {}

    private var bgmPlayer: AVAudioPlayer?
    private var sfxPlayers: [AVAudioPlayer] = []

    func playSFX(_ name: String) {
        guard let url = Bundle.main.url(forResource: name, withExtension: "wav") else {
            print("Sound not found: \(name).wav")
            return
        }
        guard let player = try? AVAudioPlayer(contentsOf: url) else { return }
        sfxPlayers = sfxPlayers.filter { $0.isPlaying }
        sfxPlayers.append(player)
        player.play()
    }

    func playBGM(_ name: String) {
        bgmPlayer?.stop()
        guard let url = Bundle.main.url(forResource: name, withExtension: "mp3") else {
            print("Sound not found: \(name).mp3")
            return
        }
        guard let player = try? AVAudioPlayer(contentsOf: url) else { return }
        player.numberOfLoops = -1
        player.volume = 0.4
        player.play()
        bgmPlayer = player
    }

    func stopBGM() {
        bgmPlayer?.stop()
        bgmPlayer = nil
    }
}

struct SoundName {
    static let correct   = "ding_correct"
    static let wrong     = "buzz_wrong"
    static let defeat    = "enemy_defeat"
    static let victory   = "victory"
    static let gameOver  = "gameover"
    static let tap       = "ui_tap"
    static let bgmHub    = "bgm_hub"
    static let bgmBattle = "bgm_battle"
}
