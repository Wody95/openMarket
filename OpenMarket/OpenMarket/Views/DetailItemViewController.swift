import UIKit
import SnapKit

@available(iOS 14, *)
class DetailItemViewController: UIViewController {
    let scrollView = UIScrollView()
    let stackView = UIStackView()
    let detailItemView = DetailItemView()
    var detailItemManager: DetailItemManager?
    var delegate: ItemListViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setupNavigationItem()

        setupScrollView()
        setupStackView()
        setupDetailItemView()
    }

    private func setupNavigationItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(DidTapEditButton))

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Market",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(closeDetailViewController))
    }

    func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        scrollView.snp.makeConstraints { view in
            view.top.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }

    private func setupStackView() {
        scrollView.addSubview(stackView)
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false

        stackView.snp.makeConstraints { view in
            view.top.equalTo(scrollView.snp.top)
            view.leading.equalTo(scrollView.snp.leading)
            view.trailing.equalTo(scrollView.snp.trailing)
            view.bottom.equalTo(scrollView.snp.bottom)
            view.width.equalTo(scrollView.snp.width)
        }
    }

    func setupDetailItemView() {
        stackView.addArrangedSubview(detailItemView)
    }

    func updateItem(item: ResponseItem) {
        self.detailItemManager = DetailItemManager(item: item, session: URLSessionProvider())

        DispatchQueue.main.async {
            self.navigationItem.title = self.detailItemManager?.item.title
            self.detailItemView.setupLabels(item: item)
        }

        detailItemManager!.downloadImages {
            self.detailItemView.setupItemImageView(images: self.detailItemManager!.images)
        }
    }

    @objc func closeDetailViewController() {
        navigationController?.popToRootViewController(animated: true)
    }

    @objc func DidTapEditButton() {
        Alerts.shared.editAndDeleteAlert(present: self) {
            self.editItem()
        } deleteHandler: {
            self.deleteItem()
        }
    }

    func editItem() {
        let registryAndPatchItemViewController = RegistryItemViewController()
        registryAndPatchItemViewController.mode = .patch
        registryAndPatchItemViewController.delegate = self.delegate
        registryAndPatchItemViewController.editMode(item: self.detailItemManager!.item)

        self.navigationController?.pushViewController(registryAndPatchItemViewController, animated: true)

    }

    func deleteItem() {
        Alerts.shared.deletePasswordAlert(present: self) { password in
            self.detailItemManager?.deleteItem(password: password) { result in
                switch result {

                case .success(_):
                    Alerts.shared.completeDeleteAlert(present: self) {
                        self.delegate?.updataItems() {
                            DispatchQueue.main.async {
                                self.navigationController?.popToRootViewController(animated: true)
                            }
                        }
                    }
                case .failure(_):
                    Alerts.shared.failPassword(present: self)
                }
            }
        }
    }

}

// MARK: - UIScrollViewDelegate
@available(iOS 14, *)
extension DetailItemViewController: UIScrollViewDelegate {}
