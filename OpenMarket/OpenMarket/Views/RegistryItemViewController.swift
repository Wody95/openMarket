import UIKit
import SnapKit

enum RegistryAndPatchMode {
    case registry, patch
}

@available(iOS 14, *)
class RegistryItemViewController: UIViewController {
    private let scrollView = UIScrollView()
    private let contentsView = RegistryItemContentsView()
    private let registryManager = RegistryManager(urlsession: URLSessionProvider())
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

    @objc func didTapRegistryItem() {
        guard var item = contentsView.createItem() else { return }
        let images = self.contentsView.imageManager.imageFiles()

        Alerts.shared.setupPasswordAlert(present: self) { password in
            item["password"] = password

            self.contentsView.indicator.startAnimating()

            switch self.mode {

            case .registry:
                self.registryItem(item: item, images: images)
            case .patch:
                self.patchItem(item: item, images: images)
            }
        }
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
    func emptyTextField()
}

@available(iOS 14, *)
extension RegistryItemViewController: RegistryItemViewControllerDelegate {
    func didTapAddImageButton(viewController: UIViewController) {
        self.present(viewController, animated: true, completion: nil)
    }

    func emptyTextField() {
        Alerts.shared.emptyTextAlert(present: self)
    }

}

// MARK: - UIScrollViewDelegate
@available(iOS 14, *)
extension RegistryItemViewController: UIScrollViewDelegate { }
