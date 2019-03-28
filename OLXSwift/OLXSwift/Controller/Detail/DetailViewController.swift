import UIKit
import WebKit

class DetailViewController: UIViewController {

    var resource: Response.Resource!
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet weak var webview: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = self.resource.title
        self.imageView.loadImageUsingUrlString(urlString: self.resource.thumbnails.large.url)
        self.loadWebView()
    }
    
    func loadWebView() {
        if let youtube = resource?.videoEmbed, let url = URL(string: "http:" + "\(youtube)") {
            let request = URLRequest(url: url)
            self.webview.load(request)
        }
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.videoEnded),
            name: NSNotification.avp,
            object: nil)
    }

    @objc
    func videoEnded() {
        print("video ended")
    }

}
