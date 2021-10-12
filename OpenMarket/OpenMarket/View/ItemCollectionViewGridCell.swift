import UIKit
import SnapKit

class ItemCollectionViewGridCell: UICollectionViewCell {
    static let identifier = "ItemCollectionViewGridCell"

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

        configureThumbnailImageView()
        configureTitleLabel()
        configureStockLabel()
        configurePriceLabel()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        self.titleLabel.text = nil
        self.priceLabel.attributedText = nil
        self.priceLabel.text = nil
        self.priceLabel.textColor = .black
        self.stockLabel.text = nil
        self.stockLabel.textColor = .black
        self.discountPriceLabel.text = nil
    }

    private func configureThumbnailImageView() {
        contentView.addSubview(thumbnailImageView)

        thumbnailImageView.snp.makeConstraints { view in
            view.width.equalTo(100)
            view.height.equalTo(100)
            view.top.equalTo(self.contentView).inset(5)
            view.centerX.equalTo(self.contentView)

        }
    }

    private func configureTitleLabel() {
        contentView.addSubview(titleLabel)

        titleLabel.snp.makeConstraints { label in
            label.top.equalTo(thumbnailImageView.snp.bottom).offset(5)
            label.centerX.equalTo(self.contentView)
        }
    }

    private func configurePriceLabel() {
        contentView.addSubview(priceLabel)
        contentView.addSubview(discountPriceLabel)

        priceLabel.snp.makeConstraints { label in
            label.centerX.equalTo(self.contentView)
            label.top.greaterThanOrEqualTo(titleLabel.snp.bottom).offset(3)
        }
    }

    private func configureStockLabel() {
        contentView.addSubview(stockLabel)

        stockLabel.snp.makeConstraints { label in
            label.bottom.equalTo(self.contentView).inset(5)
            label.centerX.equalTo(self.contentView)
        }
    }

    func setupItem(item: Item) {
        setupTitleText(text: item.title)
        setupStockText(stock: item.stock)
        setupPriceText(price: item.price, currency: item.currency)

        if let discountPrice = item.discountedPrice {
            setupDiscountPriceText(price: discountPrice, curency: item.currency)
        }

    }

    func setupTitleText(text: String) {
        self.titleLabel.text = text
    }

    func setupStockText(stock: Int) {
        var text = "잔여수량 : \(stock)"

        if stock >= 100 {
            text = "잔여수량 : 99+"
        } else if stock == 0 {
            text = "품절"
            self.stockLabel.textColor = .orange
        }

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
                label.top.equalTo(priceLabel.snp.bottom)
                label.centerX.equalTo(self.contentView)
            }

            priceLabel.textColor = .red
            priceLabel.attributedText = NSMutableAttributedString().strikethroughStyle(string: priceText)
        }
    }

    func setupThumbnailImage(image: UIImage) {
        self.thumbnailImageView.image = image
    }
}
