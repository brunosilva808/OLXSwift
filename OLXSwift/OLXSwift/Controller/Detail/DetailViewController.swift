import UIKit
import youtube_ios_player_helper_swift

class DetailViewController: UIViewController {

    var resource: Response.Resource!
    var delegate: PlayerDelegate?
    private var playerView: PlayerView = PlayerView.fromNib()
    @IBOutlet weak var topImageConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var descriptionLabel: UILabel! {
        didSet {
            self.descriptionLabel.text = resource.description
        }
    }
    @IBOutlet private weak var imageView: UIImageView! {
        didSet {
            self.imageView.loadImageUsingUrlString(urlString: self.resource.thumbnails.large.url)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
        self.loadWebView()
    }
    
    func setupView() {
        self.title = self.resource.title
        self.view.backgroundColor = .black
        self.view.backgroundColor = resource.watched ? .green : .red
    }
    
    func loadWebView() {
        if let youtubeId = resource?.videoEmbed.components(separatedBy: "/").last {
            playerView.videoId = youtubeId
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addPlayerView()
    }
    
    private func addPlayerView(){
        self.view.addSubview(playerView)
        
        self.topImageConstraint.constant = self.calculateTopDistance()
        playerView.frame = CGRect(x: 0, y: self.calculateTopDistance(), width: self.view.bounds.width, height: 240)
        playerView.delegate = self
        playerView.autoresizingMask = .flexibleWidth
    }

}

extension DetailViewController {

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .portrait
    }
}

extension DetailViewController: PlayerDelegate {

    func playerStateChanged(state: YTPlayerState) {
        if state == .playing {
            self.resource.watched = true
            self.view.backgroundColor = .green
            self.delegate?.playerStateChanged(state: state)
        }
    }
}
