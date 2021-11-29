import UIKit
import SnapKit

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

    @objc func closeDetailViewController() {
        navigationController?.popToRootViewController(animated: true)
        delegate?.updataItems()
    }

    @objc func didTapEditButton() {
        let alert = UIAlertController(title: "수정 및 삭제",
                                      message: nil,
                                      preferredStyle: .actionSheet)

        let editAlertAction = UIAlertAction(title: "Edit", style: .default) { action in
            print("EditAlertAction")
        }

        let deleteAlertAction = UIAlertAction(title: "Delete", style: .destructive) { action in
            print("DeleteAlertAction")
        }

        alert.addAction(editAlertAction)
        alert.addAction(deleteAlertAction)

        present(alert, animated: true, completion: nil)
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

        self.navigationItem.title = detailItemManager?.item.title

        detailItemView.setupLabels(item: item)

        detailItemManager!.downloadImages {
            self.detailItemView.setupItemImageView(images: self.detailItemManager!.images)
        }
    }
}

extension DetailItemViewController: UIScrollViewDelegate {}