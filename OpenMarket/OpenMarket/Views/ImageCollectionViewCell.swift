import UIKit
import SnapKit

class ImageCollectionViewCell: UICollectionViewCell {
    static let identifier = "ImageCollectionViewCell"

    private let imageAddButton = UIButton(type: .system)
    private var imageCountLabel = UILabel()
    private var imageView = UIImageView()

    var delegate: RegistryItemContentsViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: .zero)

        configureImageButton()
        configureImageCountLabel()
        configureImageView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func prepareForReuse() {
        self.imageView.image = nil
    }

    func setupLayout(index: Int) {
        if index == 0 {
            self.imageView.isHidden = true
            self.imageAddButton.isHidden = false
            self.imageCountLabel.isHidden = false
        } else {
            self.imageView.isHidden = false
            self.imageAddButton.isHidden = true
            self.imageCountLabel.isHidden = true
        }
    }

    private func configureImageButton() {
        self.contentView.addSubview(imageAddButton)

        imageAddButton.setTitle("사진추가", for: .normal)
        imageAddButton.addTarget(self, action: #selector(didTapAddImageButton), for: .touchUpInside)

        imageAddButton.snp.makeConstraints { button in
            button.centerX.equalTo(self.contentView)
            button.top.equalTo(contentView).offset(10)
        }
    }

    private func configureImageCountLabel() {
        self.contentView.addSubview(imageCountLabel)

        imageCountLabel.text = "0/5"

        imageCountLabel.snp.makeConstraints { label in
            label.centerX.equalTo(self.contentView)
            label.top.equalTo(imageAddButton.snp.bottom).offset(1)
        }
    }

    private func configureImageView() {
        self.addSubview(imageView)

        imageView.backgroundColor = .white
        imageView.snp.makeConstraints { view in
            view.top.bottom.leading.trailing.equalTo(self.contentView)
        }
    }

    func setupImageCountLabel(count: Int) {
        imageCountLabel.text = "\(count)/5"
    }

    func setupImageView(image: ImageFile) {
        self.imageView.image = image.image
    }

    @objc func didTapAddImageButton() {
        delegate?.didTapAddImages()
    }

}
