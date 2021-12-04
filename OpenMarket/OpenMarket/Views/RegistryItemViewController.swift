import UIKit
import SnapKit

enum RegistryAndPatchMode {
    case registry, patch
}

@available(iOS 14, *)
class RegistryItemViewController: UIViewController {
    let scrollView = UIScrollView()
    let contentsView = RegistryItemContentsView()
    let registryManager = RegistryAndPatchManager(urlsession: URLSessionProvider())
    var delegate: ItemListViewControllerDelegate?
    var mode: RegistryAndPatchMode = .registry

    override func viewDidLoad() {
        self.view.backgroundColor = .white
        configureNavigationBar()
        configureScrollView()
        configureContentsView()
    }

    private func configureNavigationBar() {
        if mode == .registry {
            self.navigationItem.title = "상품등록"
        } else {
            self.navigationController?.title = "\(String(describing: self.registryManager.patchItem?.title)) 수정"
        }

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "등록",
                                                                 style: .done,
                                                                 target: self,
                                                                 action: #selector(didTapRegistryItem))


    }

    func editMode(item: ResponseItem) {
        self.mode = .patch
        self.registryManager.patchItem = item
        self.navigationItem.title = "\(item.title) Edit"

        DispatchQueue.main.async {
            self.contentsView.setupPatchItem(item: item)
        }
    }

    private func configureScrollView() {
        self.view.addSubview(scrollView)
        scrollView.delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        scrollView.snp.makeConstraints { view in
            view.top.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }

    private func configureContentsView() {
        scrollView.addSubview(contentsView)
        contentsView.delegate = self
        contentsView.translatesAutoresizingMaskIntoConstraints = false

        contentsView.snp.makeConstraints { view in
            view.top.leading.trailing.bottom.equalTo(self.scrollView.contentLayoutGuide)
            view.width.equalTo(self.scrollView.frameLayoutGuide)
            view.height.equalTo(900)
        }
    }

    private func createItem() -> [String : Any]? {
        var item: [String : Any] = [:]

        guard let title = contentsView.titleTextField.text,
              let price = contentsView.priceTextField.text,
              let discountedPrice = contentsView.discountedPriceTextField.text,
              let currency = contentsView.currencyTextField.text,
              let stock = contentsView.stockTextField.text,
              let descriptions = contentsView.descriptionsTextView.text else {
            return nil
        }

        if title.isEmpty || price.isEmpty || currency.isEmpty ||
            stock.isEmpty || descriptions.isEmpty || contentsView.imageManager.imagesCount() == 0 {

            let emptyAlert = UIAlertController(title: "등록에 실패했습니다",
                                               message: "입력하지 않은 정보가 있습니다",
                                               preferredStyle: .alert)
            let ok = UIAlertAction(title: "확인", style: .default, handler: nil)

            emptyAlert.addAction(ok)
            present(emptyAlert, animated: true, completion: nil)

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

    @objc func didTapRegistryItem() {
        guard var item = createItem() else { return }
        let images = self.contentsView.imageManager.imageFiles()

        let alert = UIAlertController(title: "상품 정보 비밀번호를 입력해주세요",
                                      message: nil,
                                      preferredStyle: .alert)
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let ok = UIAlertAction(title: "등록하기", style: .default) { [weak self] _ in
            guard let password = alert.textFields?[0].text,
                  let self = self else {
                return
            }

            item["password"] = password

            self.contentsView.indicator.startAnimating()

            switch self.mode {

            case .registry:
                self.registryItem(item: item, images: images)
            case .patch:
                self.patchItem(item: item, images: images)
            }

        }

        alert.addTextField { text in
            text.placeholder = "비밀번호를 입력해주세요"
        }
        alert.addAction(ok)
        alert.addAction(cancel)

        present(alert, animated: true, completion: nil)
    }

    func registryItem(item: [String:Any], images: [ImageFile]) {
        self.registryManager.registryItem(item: item,
                                          images: images) { [weak self] responseItem in
            sleep(2)

            DispatchQueue.main.async {
                self?.contentsView.indicator.stopAnimating()

                let detailItemViewController = DetailItemViewController()
                detailItemViewController.updateItem(item: responseItem)
                detailItemViewController.delegate = self?.delegate

                self?.navigationController?.pushViewController(detailItemViewController, animated: true)

                self?.delegate?.updataItems(completion: nil)
            }
        }
    }

    func patchItem(item: [String: Any], images: [ImageFile]) {
        self.registryManager.patchItem(item: item, images: images) { [weak self] responseItem in
            sleep(2)


            DispatchQueue.main.async {
                self?.contentsView.indicator.stopAnimating()

                let detailItemViewController = DetailItemViewController()
                detailItemViewController.updateItem(item: responseItem)
                self?.navigationController?.pushViewController(detailItemViewController, animated: true)

                self?.delegate?.updataItems(completion: nil)
            }
        }
    }
}

// MARK: - Protocol RegistryItemViewControllerDelegate
protocol RegistryItemViewControllerDelegate {
    func didTapAddImageButton(viewController: UIViewController)
}

@available(iOS 14, *)
extension RegistryItemViewController: RegistryItemViewControllerDelegate {
    func didTapAddImageButton(viewController: UIViewController) {
        self.present(viewController, animated: true, completion: nil)
    }

}

// MARK: - UIScrollViewDelegate
@available(iOS 14, *)
extension RegistryItemViewController: UIScrollViewDelegate { }
