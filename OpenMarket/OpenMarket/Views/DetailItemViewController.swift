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
                                                            action: #selector(didTapEditButton))

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
        delegate?.updataItems()
    }

    @objc func didTapEditButton() {
        let alert = UIAlertController(title: "수정 및 삭제",
                                      message: nil,
                                      preferredStyle: .actionSheet)

        let editAlertAction = UIAlertAction(title: "Edit", style: .default) { action in

        }

        let deleteAlertAction = UIAlertAction(title: "Delete", style: .destructive) { action in

        }

        alert.addAction(editAlertAction)
        alert.addAction(deleteAlertAction)

        present(alert, animated: true, completion: nil)
    }

    func editItem() {
        self.navigationController?.pushViewController(RegistryItemViewController(), animated: true)
    }

}

// MARK: - UIScrollViewDelegate
@available(iOS 14, *)
extension DetailItemViewController: UIScrollViewDelegate {}
