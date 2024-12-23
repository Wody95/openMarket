import UIKit
import SnapKit

@available(iOS 14, *)
class RegistryItemViewController: UIViewController {
    let scrollView = UIScrollView()
    let contentsView = CreateItemContentsView()
    let registryManager = RegistryManager(urlsession: URLSessionProvider())

    override func viewDidLoad() {

        self.view.backgroundColor = .white
        configureNavigationBar()
        configureScrollView()
        configureContentsView()
    }

    private func configureNavigationBar() {
        self.navigationItem.title = "상품등록"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "등록",
                                                                 style: .done,
                                                                 target: self,
                                                                 action: #selector(didTapRegistryItem))
    }

    private func configureScrollView() {
        self.view.addSubview(scrollView)
        scrollView.delegate = self

        scrollView.snp.makeConstraints { view in
            view.top.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }

    private func configureContentsView() {
        scrollView.addSubview(contentsView)
        contentsView.delegate = self

        contentsView.snp.makeConstraints { view in
            view.top.leading.trailing.bottom.equalTo(self.scrollView.contentLayoutGuide)
            view.width.equalTo(self.scrollView.frameLayoutGuide)
            view.height.equalTo(900)
        }
    }

    @objc func didTapRegistryItem() {
        var item: [String:Any] = [:]

        guard let title = contentsView.titleTextField.text,
              let price = contentsView.priceTextField.text,
              let crrency = contentsView.currencyTextField.text,
              let stock = contentsView.stockTextField.text,
              let descriptions = contentsView.descriptionsTextView.text else {
            return
        }

        let alert = UIAlertController(title: "상품 정보 비밀번호를 입력해주세요",
                                      message: nil,
                                      preferredStyle: .alert)
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let ok = UIAlertAction(title: "등록하기", style: .default) { [weak self] _ in
            guard let password = alert.textFields?[0].text,
                  let self = self else {
                return
            }

            item["title"] = title
            item["price"] = price
            item["currency"] = crrency
            item["stock"] = stock
            item["descriptions"] = descriptions
            item["password"] = password

            if let discountedPrice = (self.contentsView.discountedPriceTextField.text) {
                item["discounted_price"] = discountedPrice
            }

            self.registryManager.registryItem(item: item,
                                         images: self.contentsView.imageManager.imageFiles())
        }

        alert.addTextField { text in
            text.placeholder = "비밀번호를 입력해주세요"
        }
        alert.addAction(ok)
        alert.addAction(cancel)

        present(alert, animated: true, completion: nil)
    }
}

// MARK: - Protocol CreateItemViewControllerDelegate
protocol CreateItemViewControllerDelegate {
    func didTapAddImageButton(viewController: UIViewController)
}

@available(iOS 14, *)
extension RegistryItemViewController: CreateItemViewControllerDelegate {
    func didTapAddImageButton(viewController: UIViewController) {
        self.present(viewController, animated: true, completion: nil)
    }

}

// MARK: - UIScrollViewDelegate
@available(iOS 14, *)
extension RegistryItemViewController: UIScrollViewDelegate { }
