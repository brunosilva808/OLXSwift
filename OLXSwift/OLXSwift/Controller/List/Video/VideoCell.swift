import UIKit

class VideoCell: UITableViewCell, ModelPresenterCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    var model: Response.Resource? {
        didSet {
            guard let model = self.model else { return }
            self.titleLabel.text = model.title
            self.titleLabel.textColor = model.watched ? .green : .red
            self.thumbnailImageView.loadImageUsingUrlString(urlString: model.thumbnails.large.url)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        self.backgroundColor = .black
    }
    
    @IBAction func shareButtonPressed(_ sender: Any) {
        if let link = model?.videoEmbed {
            let items = [URL(string: "http:" + link)]
            let activityViewController = UIActivityViewController(activityItems: items as [Any], applicationActivities: nil)
            self.window?.rootViewController?.present(activityViewController, animated: true, completion: nil)
        }
    }
}
