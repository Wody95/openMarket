import UIKit
import SnapKit

class ItemCollectionViewListCell: UICollectionViewCell {
    static let identifier = "ItemCollectionViewListCell"

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20)
        label.text = "titleLabel"

        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "priceLabel"

        return label
    }()

    private let discountPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = nil

        return label
    }()

    private let stockLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "stockLabel"

        return label
    }()

    private let thumbnailImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
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
            view.width.lessThanOrEqualTo(60)
            view.height.lessThanOrEqualTo(50)
            view.top.leading.equalTo(self.contentView).inset(5)
            view.bottom.lessThanOrEqualTo(self.contentView).inset(5)

        }
    }

    private func configureTitleLabel() {
        contentView.addSubview(titleLabel)

        titleLabel.snp.makeConstraints { label in
            label.width.lessThanOrEqualTo(180)
            label.top.equalTo(thumbnailImageView.snp.top)
            label.leading.equalTo(thumbnailImageView.snp.trailing).offset(5)
        }
    }

    private func configureStockLabel() {
        contentView.addSubview(stockLabel)

        stockLabel.snp.makeConstraints { label in
            label.width.greaterThanOrEqualTo(30)
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
                label.bottom.equalTo(priceLabel.snp.bottom)
                label.leading.equalTo(priceLabel.snp.trailing).offset(5)
            }

            priceLabel.textColor = .red
            priceLabel.attributedText = NSMutableAttributedString().strikethroughStyle(string: priceText)
        }
    }

    func setupThumbnailImage(image: UIImage?) {
        DispatchQueue.main.async {
            self.thumbnailImageView.image = image
        }
    }
}
