import UIKit
import SnapKit

class ItemCollectionViewCell: UICollectionViewCell {
    static let identifier = "ItemCollectionViewCell"

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20)
        label.text = "titleLabel"

        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.text = "priceLabel"

        return label
    }()

    private let discountPriceLabel: UILabel = {
        let label = UILabel()
        label.text = nil

        return label
    }()

    private let stockLabel: UILabel = {
        let label = UILabel()
        label.text = "stockLabel"

        return label
    }()

    private let thumbnailImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "testImage")
        
        return image
    }()


    required init?(coder: NSCoder) {
        super.init(coder: coder)

    }



    override init(frame: CGRect) {
        super.init(frame: .zero)

        self.contentView.backgroundColor = .white

        configureContentSubView()
    }

    private func configureContentSubView() {
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(stockLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(discountPriceLabel)
    }

    func setupListCell(itemViewMode: ViewMode) {
        configureThumbnailImageView(itemViewMode)
        configureTitleLabel(itemViewMode)
        configureStockLabel(itemViewMode)
        configurePriceLabel(itemViewMode)
    }

    private func configureThumbnailImageView(_ itemViewMode: ViewMode) {
        if itemViewMode == .list {
            thumbnailImageView.snp.makeConstraints { view in
                view.width.equalTo(60)
                view.height.equalTo(50)
                view.top.leading.bottom.equalTo(self.contentView).inset(5)

            }
        } else {
            thumbnailImageView.snp.makeConstraints { view in
                view.width.equalTo(120)
                view.height.equalTo(180)
                view.top.equalTo(self.contentView).inset(5)
                view.leading.trailing.equalTo(self.contentView).inset(8)
            }
        }

    }

    private func configureTitleLabel(_ itemViewMode: ViewMode) {
        if itemViewMode == .list {
            titleLabel.snp.makeConstraints { label in
                label.top.equalTo(thumbnailImageView.snp.top)
                label.leading.equalTo(thumbnailImageView.snp.trailing).offset(5)
            }
        } else {
            titleLabel.snp.makeConstraints { label in
                label.top.equalTo(thumbnailImageView.snp.top).offset(5)
                label.centerX.equalTo(self.contentView)
            }
        }

    }

    private func configureStockLabel(_ itemViewMode: ViewMode) {
        if itemViewMode == .list {
            stockLabel.snp.makeConstraints { label in
                label.top.equalTo(titleLabel.snp.top)
                label.trailing.equalTo(self.contentView).inset(5)
                label.leading.greaterThanOrEqualTo(titleLabel.snp.trailing).offset(10)
            }
        } else {
            stockLabel.snp.makeConstraints { label in
                label.bottom.equalTo(self.contentView).inset(5)
                label.centerX.equalTo(self.contentView)
            }
        }

    }

    private func configurePriceLabel(_ itemViewMode: ViewMode) {
        if itemViewMode == .list {
            priceLabel.snp.makeConstraints { label in
                label.bottom.equalTo(thumbnailImageView.snp.bottom)
                label.leading.equalTo(thumbnailImageView.snp.trailing).offset(5)
            }
        } else {
            priceLabel.snp.makeConstraints { label in
                label.centerY.equalTo(priceLabel.snp.bottom)
            }
        }

    }

    func setupTitleText(text: String) {
        self.titleLabel.text = text
    }

    func setupStockText(stock: Int) {
        let text = "\(stock)"
        self.stockLabel.text = text
    }

    func setupPriceText(price: Int, currency: String) {
        let text = "\(currency) \(price)"
        self.priceLabel.text = text
    }

    func setupDiscountPriceText(price: Int, curency: String) {
        let text = "\(curency) \(price)"
        self.discountPriceLabel.text = text

        if discountPriceLabel.text != nil,
           let priceText = priceLabel.text {

            discountPriceLabel.snp.makeConstraints { label in
                label.bottom.equalTo(priceLabel.snp.bottom)
                label.leading.equalTo(priceLabel.snp.trailing).offset(5)
            }

            priceLabel.textColor = .red
            let attributeString = NSMutableAttributedString(string: priceText)
            attributeString.addAttribute(.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attributeString.length))
            priceLabel.attributedText = attributeString
        }
    }

    func setupThumbnailImage(image: UIImage) {
        self.thumbnailImageView.image = image
    }
}
