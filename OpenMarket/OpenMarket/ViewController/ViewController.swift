import UIKit
import SnapKit

protocol ViewControllerDelegate {
    func didTapViewMode()
    func readItemsData()
}

@available(iOS 14.0, *)
class ViewController: UIViewController {
    let itemManager = ItemManager(urlsession: URLSessionProvider())
    let rightSideView = RightSideView(frame: CGRect(x: 0, y: 0, width: 70, height: 37))
    var collectionView = ItemCollectionView(frame: .zero,
                                            collectionViewLayout: UICollectionViewFlowLayout())


    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.async {
            self.itemManager.readItems(page: self.itemManager.lastPage)
            self.view.setNeedsLayout()
        }

        configureNavigationBar()
        configureCollectionView()
        setupCollectionViewLayout()
    }

    private func configureNavigationBar() {
        self.navigationItem.title = "Market"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightSideView)
        self.rightSideView.viewControllerDelegate = self
    }

    private func configureCollectionView() {
        collectionView.register(ItemCollectionViewCell.self,
                                forCellWithReuseIdentifier: ItemCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white

        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { view in
            view.top.bottom.leading.trailing.equalTo(self.view)
        }
    }

    private func setupCollectionViewLayout() {
        let configList = UICollectionLayoutListConfiguration(appearance: .plain)
        let configGrid = UICollectionViewFlowLayout()

        if rightSideView.itemViewMode == .list {
            collectionView.collectionViewLayout = UICollectionViewCompositionalLayout.list(using: configList)
        } else {
            collectionView.collectionViewLayout = configGrid
        }
    }
}

// - MARK: ViewControllerDelegate
@available(iOS 14.0, *)
extension ViewController: ViewControllerDelegate {
    func readItemsData() {
        self.view.setNeedsLayout()
    }

    func didTapViewMode() {
        let topIndex = IndexPath(row: 0, section: 0)
        self.setupCollectionViewLayout()
        self.collectionView.scrollToItem(at: topIndex, at: .top, animated: false)
        self.view.setNeedsLayout()
    }
}

// - MARK: UICollectionViewDelegate
@available(iOS 14.0, *)
extension ViewController: UICollectionViewDelegate {

}

// - MARK: UICollecdtionViewDataSource
@available(iOS 14.0, *)
extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return self.itemManager.items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCollectionViewCell.identifier, for: indexPath) as? ItemCollectionViewCell else { return UICollectionViewCell() }

        let itemTitle = self.itemManager.items[indexPath.row].title
        cell.setupTitleText(text: itemTitle)

        return cell
    }
}


// - MARK: UICollectionViewFlowLayout
@available(iOS 14.0, *)
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width/2.1, height: view.frame.height/3.3)
    }
}
