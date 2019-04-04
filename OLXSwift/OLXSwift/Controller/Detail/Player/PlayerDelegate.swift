import Foundation
import youtube_ios_player_helper_swift

protocol PlayerDelegate: class {
    func playerStateChanged(state: YTPlayerState)
}
