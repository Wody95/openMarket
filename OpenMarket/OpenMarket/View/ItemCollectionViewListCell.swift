import UIKit
import SnapKit

class ItemCollectionViewListCell: UICollectionViewCell {
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

    private let currencyLabel: UILabel = {
        let label = UILabel()
        label.text = "currencyLabel"

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

        configureThumbnailImageView()
        configureTitleLabel()
        configureStockLabel()
        configurePriceLabel()
        configureCurrencyLabel()
    }

    private func configureThumbnailImageView() {
        contentView.addSubview(thumbnailImageView)

        thumbnailImageView.snp.makeConstraints { view in
            view.width.equalTo(60)
            view.height.equalTo(50)
            view.top.leading.bottom.equalTo(self.contentView).inset(5)

        }
    }

    private func configureTitleLabel() {
        contentView.addSubview(titleLabel)

        titleLabel.snp.makeConstraints { label in
            label.top.equalTo(thumbnailImageView.snp.top)
            label.leading.equalTo(thumbnailImageView.snp.trailing).offset(5)
        }
    }

    private func configureStockLabel() {
        contentView.addSubview(stockLabel)

        stockLabel.snp.makeConstraints { label in
            label.top.equalTo(titleLabel.snp.top)
            label.trailing.equalTo(self.contentView).inset(5)
            label.leading.greaterThanOrEqualTo(titleLabel.snp.trailing).offset(10)
        }
    }

    private func configurePriceLabel() {
        contentView.addSubview(priceLabel)
        contentView.addSubview(discountPriceLabel)

        priceLabel.snp.makeConstraints { label in
            label.bottom.equalTo(thumbnailImageView.snp.bottom)
            label.leading.equalTo(thumbnailImageView.snp.trailing).offset(5)
        }
    }

    private func configureCurrencyLabel() {
        contentView.addSubview(currencyLabel)
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
