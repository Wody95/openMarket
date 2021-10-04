import UIKit

class RightSideView: UIView {
    let listAndGridImage = UIImage(systemName: "list.dash")
    let listAndGridButton = UIButton(type: .system)
    let addItemImage = UIImage(systemName: "plus")
    let addItemView = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)

        listAndGridButton.frame = CGRect(x: 10, y: 8, width: 20, height: 20)
        listAndGridButton.setImage(listAndGridImage, for: .normal)
        self.addSubview(listAndGridButton)

        addItemView.frame = CGRect(x: 50, y: 10, width: 16, height: 16)
        addItemView.setImage(addItemImage, for: .normal)
        self.addSubview(addItemView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
