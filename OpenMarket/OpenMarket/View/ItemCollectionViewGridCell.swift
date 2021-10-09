import UIKit
import SnapKit

class ItemCollectionViewGridCell: UICollectionViewCell {
    static let identifier = "ItemCollectionViewCell"

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20)
        label.text = "titleLabel"

        return label
    }()

    required init?(coder: NSCoder) {
        super.init(coder: coder)

    }

    override init(frame: CGRect) {
        super.init(frame: .zero)

        self.contentView.backgroundColor = .white

        configureTitleLabel()
    }

    private func configureTitleLabel() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { label in
            label.center.equalTo(self.contentView)
        }
    }

    func setupTitleText(text: String) {
        self.titleLabel.text = text
    }
}
