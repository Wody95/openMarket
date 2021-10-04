import UIKit

class ViewController: UIViewController {

    let rightSideView = RightSideView(frame: CGRect(x: 0, y: 0, width: 70, height: 37))

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
    }

    private func setupNavigationBar() {
        self.navigationItem.title = "Market"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightSideView)
    }
}
