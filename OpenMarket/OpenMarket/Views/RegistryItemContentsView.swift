import UIKit
import PhotosUI



@available(iOS 14, *)
class RegistryItemContentsView: UIView, UINavigationControllerDelegate {
    let titleTextField = UITextField()
    let priceTextField = UITextField()
    let discountedPriceTextField = UITextField()
    let currencyTextField = UITextField()
    let stockTextField = UITextField()
    let descriptionsTextView = UITextView()
    let passwordTextField = UITextField()
    let indicator = UIActivityIndicatorView()

    let imagePickerButton: UIButton = UIButton(type: .system)
    var imagePicker: PHPickerViewController = {
        var pickerConfiguration = PHPickerConfiguration(photoLibrary: .shared())
        let pickerFilter = PHPickerFilter.any(of: [.images])

        pickerConfiguration.filter = pickerFilter
        pickerConfiguration.selectionLimit = 5

        let imagePicker = PHPickerViewController(configuration: pickerConfiguration)

        return imagePicker
    }()
    var delegate: RegistryItemViewControllerDelegate?

    let imagesCollectionView = UICollectionView(frame: .zero,
                                                collectionViewLayout: UICollectionViewLayout())
    var imageManager = ImageManager()

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = .white

        configureImagePicker()
        configureImagesCollectionView()
        configureTitleTextField()
        configurePriceTextField()
        configureDiscountedPriceTextField()
        configureCurrencyTextField()
        configureStockTextField()
        configureDescriptionsTextView()
        configureIndicator()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureImagePicker() {
        imagePicker.delegate = self
        imagePicker.modalPresentationStyle = .fullScreen
    }

    private func configureImagesCollectionView() {
        addSubview(imagesCollectionView)

        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.scrollDirection = .horizontal
        flowlayout.minimumLineSpacing = 10

        imagesCollectionView.backgroundColor = .white
        imagesCollectionView.collectionViewLayout = flowlayout
        imagesCollectionView.delegate = self
        imagesCollectionView.dataSource = self
        imagesCollectionView.register(ImageCollectionViewCell.self,
                                     forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        imagesCollectionView.contentInset = UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 0)
        imagesCollectionView.translatesAutoresizingMaskIntoConstraints = false

        imagesCollectionView.snp.makeConstraints { view in
            view.height.equalTo(100)
            view.top.equalTo(self).inset(10)
            view.leading.trailing.equalTo(self)
        }
    }

    private func configureTitleTextField() {
        self.addSubview(titleTextField)

        titleTextField.placeholder = "제품 이름"
        titleTextField.borderStyle = .line
        titleTextField.translatesAutoresizingMaskIntoConstraints = false

        titleTextField.snp.makeConstraints { field in
            field.top.equalTo(imagesCollectionView.snp.bottom).offset(20)
            field.leading.trailing.equalTo(self).inset(10)
        }
    }

    private func configurePriceTextField() {
        self.addSubview(priceTextField)

        priceTextField.placeholder = "가격"
        priceTextField.borderStyle = .line
        priceTextField.keyboardType = .numberPad
        priceTextField.translatesAutoresizingMaskIntoConstraints = false

        priceTextField.snp.makeConstraints { field in
            field.top.equalTo(titleTextField.snp.bottom).offset(20)
            field.leading.trailing.equalTo(self).inset(10)
        }
    }

    private func configureDiscountedPriceTextField() {
        self.addSubview(discountedPriceTextField)

        discountedPriceTextField.placeholder = "할인가격 (옵션)"
        discountedPriceTextField.borderStyle = .line
        discountedPriceTextField.keyboardType = .numberPad
        discountedPriceTextField.translatesAutoresizingMaskIntoConstraints = false

        discountedPriceTextField.snp.makeConstraints { field in
            field.top.equalTo(priceTextField.snp.bottom).offset(20)
            field.leading.trailing.equalTo(self).inset(10)
        }
    }

    private func configureCurrencyTextField() {
        self.addSubview(currencyTextField)

        currencyTextField.placeholder = "화폐단위(KRW)"
        currencyTextField.text = "KRW"
        currencyTextField.borderStyle = .line
        currencyTextField.translatesAutoresizingMaskIntoConstraints = false

        currencyTextField.snp.makeConstraints { field in
            field.top.equalTo(discountedPriceTextField.snp.bottom).offset(20)
            field.leading.trailing.equalTo(self).inset(10)
        }
    }

    private func configureStockTextField() {
        self.addSubview(stockTextField)

        stockTextField.placeholder = "재고 수량"
        stockTextField.borderStyle = .line
        stockTextField.keyboardType = .numberPad
        stockTextField.translatesAutoresizingMaskIntoConstraints = false

        stockTextField.snp.makeConstraints { field in
            field.top.equalTo(currencyTextField.snp.bottom).offset(20)
            field.leading.trailing.equalTo(self).inset(10)
        }
    }

    private func configureDescriptionsTextView() {
        self.addSubview(descriptionsTextView)
        self.descriptionsTextView.delegate = self

        descriptionsTextView.text = "제품 설명"
        descriptionsTextView.textColor = .lightGray
        descriptionsTextView.backgroundColor = .white
        descriptionsTextView.font = UIFont.preferredFont(forTextStyle: .body)
        descriptionsTextView.isScrollEnabled = false
        descriptionsTextView.layer.borderWidth = 1.0
        descriptionsTextView.translatesAutoresizingMaskIntoConstraints = false

        descriptionsTextView.snp.makeConstraints { view in
            view.top.equalTo(stockTextField.snp.bottom).offset(20)
            view.leading.trailing.equalTo(self).inset(10)
        }
    }

    private func configureIndicator() {
        self.addSubview(indicator)
        indicator.hidesWhenStopped = true
        indicator.isHidden = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.style = .large

        indicator.snp.makeConstraints {
            $0.centerX.centerY.equalTo(self)
        }
    }

    func startIndicator() {
        indicator.startAnimating()
    }

    func stopIndicator() {
        indicator.stopAnimating()
    }

    func setupPatchItem(item: ResponseItem) {
        titleTextField.text = item.title
        priceTextField.text = "\(item.price)"
        currencyTextField.text = item.currency
        stockTextField.text = "\(item.stock)"
        descriptionsTextView.text = item.descriptions
        descriptionsTextView.textColor = .black

        if let discountPrice = item.discountedPrice {
            discountedPriceTextField.text = "\(discountPrice)"
        }
    }

    func createItem() -> [String : Any]? {
        var item: [String : Any] = [:]

        guard let title = titleTextField.text,
              let price = priceTextField.text,
              let discountedPrice = discountedPriceTextField.text,
              let currency = currencyTextField.text,
              let stock = stockTextField.text,
              let descriptions = descriptionsTextView.text else {
            return nil
        }

        if title.isEmpty || price.isEmpty || currency.isEmpty ||
            stock.isEmpty || descriptions.isEmpty || imageManager.imagesCount() == 0 {

            delegate?.emptyTextField()

            return nil
        }

        item["title"] = title
        item["price"] = price
        item["currency"] = currency
        item["stock"] = stock
        item["descriptions"] = descriptions

        if !discountedPrice.isEmpty {
            item["discounted_price"] = discountedPrice
        }

        return item
    }

    @objc func didTapAddImage() {
        guard let delegate = self.delegate else { return }

        delegate.didTapAddImageButton(viewController: imagePicker)
    }
}

// MARK: - RegistryItemContentsViewDelegate
protocol RegistryItemContentsViewDelegate {
    func didTapAddImages()
}

@available(iOS 14, *)
extension RegistryItemContentsView: RegistryItemContentsViewDelegate {
    func didTapAddImages() {
        guard let delegate = self.delegate else {
            return
        }

        delegate.didTapAddImageButton(viewController: self.imagePicker)
    }
}

// MARK: - UICollectionViewDelegate
@available(iOS 14, *)
extension RegistryItemContentsView: UICollectionViewDelegate {}

// MARK: - UICollectionViewDataSource
@available(iOS 14, *)
extension RegistryItemContentsView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageManager.imagesCount() + 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as? ImageCollectionViewCell else { return UICollectionViewCell() }

        if indexPath.row == 0 {
            cell.delegate = self
            cell.setupImageCountLabel(count: imageManager.imagesCount())
        } else {
            cell.setupImageView(image: imageManager.imageFile(index: indexPath.row - 1))
        }

        cell.layer.borderWidth = 0.5
        cell.setupLayout(index: indexPath.row)

        return cell
    }
}

@available(iOS 14, *)
extension RegistryItemContentsView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 70, height: 70)
    }
}

// MARK: - PHPickerViewControllerDelegate
@available(iOS 14, *)
extension RegistryItemContentsView: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        self.imageManager.reset()

        for item in results {
            let itemProvider = item.itemProvider

            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                var filename = ""
                var filetype = ""

                itemProvider.loadFileRepresentation(forTypeIdentifier: "public.item") { url, error in
                    if error != nil {
                        print("error")
                    } else {
                        if let url = url {
                            filename = url.lastPathComponent
                            filetype = url.pathExtension
                        }
                    }
                }

                itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                    guard let image = image as? UIImage,
                          let data = image.pngData(),
                          let self = self else { return }

                    let imageFile = ImageFile(image: image, filename: filename, data: data, type: filetype)

                    DispatchQueue.main.async {
                        self.imageManager.append(image: imageFile)
                        if self.imageManager.isCompleteAddImage(results.count) {
                            self.imagesCollectionView.reloadData()
                        }
                    }
                }
            }
        }
    }
}

// MARK: - UITextViewDelegate
@available(iOS 14, *)
extension RegistryItemContentsView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "제품 설명"
            textView.textColor = .lightGray
        }
    }
}

// MARK: - UITextField
@available(iOS 14, *)
extension UITextField {
    func isEmpty(_ textField: UITextField) -> Bool {
        guard let text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            return true
        }

        if text.isEmpty {
            return true
        } else {
            return false
        }
    }
}
