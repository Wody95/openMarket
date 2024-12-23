import UIKit
import SnapKit

class DetailItemView: UIView {
    let scrollView = UIScrollView()
    let imagePageControl = UIPageControl(frame: .zero)
    var itemImages = [UIImage]()

    let titleLabel = UILabel()
    let stockLabel = UILabel()
    let priceLabel = UILabel()
    let discountPriceLabel = UILabel()
    let descriptionsLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: .zero)

        self.backgroundColor = .white

        setupScrollView()
        setupPageControl()
        setupTitleLabel()
        setupStockLabel()
        setupPriceLabel()
        setupDiscountPriceLabel()
        setupDescriptionsLabel()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func setupScrollView() {
        addSubview(scrollView)
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false

        scrollView.snp.makeConstraints { view in
            view.top.leading.trailing.equalTo(self)
            view.height.equalTo(self.snp.width)
        }
    }

    func setupItemImageView(images: [UIImage?]) {

        DispatchQueue.main.async {
            for i in 0..<images.count {
                let imageView = UIImageView()
                imageView.contentMode = .scaleAspectFit
                let xPos = self.frame.width * CGFloat(i)

                imageView.frame = CGRect(x: xPos, y: 0,
                                         width: self.scrollView.bounds.width,
                                         height: self.scrollView.bounds.height)
                imageView.image = images[i]

                self.scrollView.addSubview(imageView)
                self.scrollView.contentSize.width = imageView.frame.width * CGFloat(i+1)
            }
        }

        DispatchQueue.main.async {
            self.imagePageControl.numberOfPages = images.count
        }
    }

    func setupPageControl() {
        addSubview(imagePageControl)

        imagePageControl.currentPageIndicatorTintColor = .darkGray
        imagePageControl.pageIndicatorTintColor = .lightGray
        imagePageControl.hidesForSinglePage = true

        imagePageControl.snp.makeConstraints {
            $0.centerX.equalTo(self)
            $0.top.equalTo(scrollView.snp.bottom)
        }
    }

    func setupPageControlSelectedPage(currentPage: Int) {
        imagePageControl.currentPage = currentPage
    }

    func setupTitleLabel() {
        addSubview(titleLabel)

        titleLabel.text = "타이틀"

        titleLabel.snp.makeConstraints { label in
            label.top.equalTo(scrollView.snp.bottom).offset(25)
            label.leading.equalTo(self).inset(10)
        }
    }

    func setupStockLabel() {
        addSubview(stockLabel)

        stockLabel.text = "남은 수량 : 100"

        stockLabel.snp.makeConstraints { label in
            label.top.equalTo(titleLabel.snp.top)
            label.leading.greaterThanOrEqualTo(titleLabel.snp.trailing).offset(10)
            label.trailing.equalTo(self).inset(10)
        }
    }

    func setupPriceLabel() {
        addSubview(priceLabel)

        priceLabel.text = "KRW 100,000"

        priceLabel.snp.makeConstraints { label in
            label.top.equalTo(titleLabel.snp.bottom).offset(10)
            label.leading.trailing.equalTo(self).inset(10)
        }
    }

    func setupDiscountPriceLabel() {
        addSubview(discountPriceLabel)

        discountPriceLabel.text = "KRW 80,000"

        discountPriceLabel.snp.makeConstraints { label in
            label.top.equalTo(priceLabel.snp.bottom)
            label.leading.trailing.equalTo(self).inset(10)
        }
    }

    func setupDescriptionsLabel() {
        addSubview(descriptionsLabel)

        descriptionsLabel.numberOfLines = 0
        descriptionsLabel.text = "제품 설명입니다"

        descriptionsLabel.snp.makeConstraints { label in
            if discountPriceLabel.text == nil {
                label.top.equalTo(priceLabel.snp.bottom).offset(10)
            } else {
                label.top.equalTo(discountPriceLabel.snp.bottom).offset(10)
            }

            label.leading.trailing.bottom.equalTo(self).inset(10)
        }

    }

    func setupLabels(item: ResponseItem) {
        titleLabel.text = item.title
        stockLabel.text = "\(item.stock)"
        priceLabel.text = "\(item.currency) \(item.price)"
        descriptionsLabel.text = item.descriptions

        if let discountPrice = item.discountedPrice {
            discountPriceLabel.text = "\(item.currency) \(discountPrice)"
        }

        self.setNeedsLayout()
    }
    
}

extension DetailItemView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let value = scrollView.contentOffset.x / scrollView.frame.size.width
        setupPageControlSelectedPage(currentPage: Int(round(value)))
    }
}
