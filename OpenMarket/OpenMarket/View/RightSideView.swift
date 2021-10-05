import UIKit



class RightSideView: UIView {
    private let listViewModeImage = UIImage(systemName: "list.dash")
    private let gridViewModeImage = UIImage(systemName: "square.grid.2x2.fill")
    private let viewModeButton = UIButton(type: .system)
    private let addItemImage = UIImage(systemName: "plus")
    private let addItemView = UIButton(type: .system)
    var viewControllerDelegate: ViewControllerDelegate?
    var itemViewMode: ViewMode = .list

    override init(frame: CGRect) {
        super.init(frame: frame)

        viewModeButton.frame = CGRect(x: 10, y: 8, width: 20, height: 20)
        viewModeButton.setImage(gridViewModeImage, for: .normal)
        viewModeButton.addTarget(superview, action: #selector(didTapViewModeButton), for: .touchUpInside)
        self.addSubview(viewModeButton)


        addItemView.frame = CGRect(x: 50, y: 10, width: 16, height: 16)
        addItemView.setImage(addItemImage, for: .normal)
        self.addSubview(addItemView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func didTapViewModeButton() {
        guard let delegate = viewControllerDelegate else { return }

        if self.itemViewMode == .list {
            self.itemViewMode = .grid
            self.viewModeButton.setImage(listViewModeImage, for: .normal)
        } else {
            self.itemViewMode = .list
            self.viewModeButton.setImage(gridViewModeImage, for: .normal)
        }

        DispatchQueue.main.async {
            self.setNeedsLayout()
            delegate.didTapViewMode()
        }
    }
}
