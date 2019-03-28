import Foundation
import youtube_ios_player_helper_swift

protocol PlayerDelegate {
    func playerStateChanged(state: YTPlayerState)
}
