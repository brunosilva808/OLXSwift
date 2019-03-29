import UIKit

class VideoCell: UITableViewCell, ModelPresenterCell {
    
    @IBOutlet private weak var titleLabel: UILabel!

    var model: Response.Resource? {
        didSet {
            guard let model = self.model else { return }
            self.backgroundColor = model.watched ? .green : .red
            self.titleLabel.text = model.title
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func shareButtonPressed(_ sender: Any) {
        if let link = model?.videoEmbed {
            let items = [URL(string: "http:" + link)]
            let activityViewController = UIActivityViewController(activityItems: items as [Any], applicationActivities: nil)
            self.window?.rootViewController?.present(activityViewController, animated: true, completion: nil)
        }
    }
}
