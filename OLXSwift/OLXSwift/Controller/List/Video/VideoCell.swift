import UIKit

class VideoCell: UITableViewCell, ModelPresenterCell {
    
    @IBOutlet private weak var titleLabel: UILabel!

    var model: Response.Resource? {
        didSet {
            guard let model = self.model else { return }
            self.titleLabel.text = model.title
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
