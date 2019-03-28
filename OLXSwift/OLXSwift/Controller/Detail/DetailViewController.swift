import UIKit
import youtube_ios_player_helper_swift

class DetailViewController: UIViewController {

    var resource: Response.Resource!
    private var playerView: PlayerView = PlayerView.fromNib()
    
    @IBOutlet private weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = self.resource.title
        self.imageView.loadImageUsingUrlString(urlString: self.resource.thumbnails.large.url)
        self.loadWebView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addPlayerView()
    }
    
    private func addPlayerView(){
        self.view.addSubview(playerView)
        playerView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 240)
        playerView.autoresizingMask = .flexibleWidth
    }

    func loadWebView() {
        if let youtubeId = resource?.videoEmbed.components(separatedBy: "/").last {
            playerView.videoId = youtubeId
        }
    }

}

extension DetailViewController {

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .portrait
    }
    
}
