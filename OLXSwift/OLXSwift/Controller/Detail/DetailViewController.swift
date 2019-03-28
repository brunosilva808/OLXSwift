import UIKit
import youtube_ios_player_helper_swift

class DetailViewController: UIViewController {

    var resource: Response.Resource!

    @IBOutlet private weak var playerView: YTPlayerView!
    @IBOutlet private weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = self.resource.title
//        self.imageView.loadImageUsingUrlString(urlString: self.resource.thumbnails.large.url)
        self.loadWebView()
    }

    func loadWebView() {
        if  let youtubeId = resource?.videoEmbed.components(separatedBy: "/").last {
            _ = playerView.load(videoId: youtubeId)
        }
    }

}

extension DetailViewController {

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .portrait
    }
    
}
