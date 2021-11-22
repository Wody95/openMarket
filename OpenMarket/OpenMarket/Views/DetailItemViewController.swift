import UIKit
import SnapKit

class DetailItemViewController: UIViewController {

    let scrollView = UIScrollView()
    let stackView = UIStackView()
    let detailItemView = DetailItemView()
    var detailItemManager: DetailItemManager?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white

        setupScrollView()
        setupStackView()
        setupDetailItemView()
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

    func setupDetailViewLabel() {
        if let manager = detailItemManager {
            detailItemView.setupLabels(item: manager.item)
        }
    }


}

extension DetailItemViewController: UIScrollViewDelegate {}
