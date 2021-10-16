import UIKit
import SnapKit

@available(iOS 14.0, *)
class ViewController: UIViewController {
    let itemManager = ItemManager(urlsession: URLSessionProvider())
    let rightSideView = RightSideView(frame: CGRect(x: 0, y: 0, width: 70, height: 37))
    var collectionView = ItemCollectionView(frame: .zero,
                                            collectionViewLayout: UICollectionViewFlowLayout())
    var fetchingMore = true

    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        configureCollectionView()
        setupCollectionViewLayout()
        setupItemManager()
    }

    private func configureNavigationBar() {
        self.navigationItem.title = "Market"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightSideView)
        self.rightSideView.viewControllerDelegate = self
    }

    private func configureCollectionView() {
        collectionView.register(ItemCollectionViewListCell.self,
                                forCellWithReuseIdentifier: ItemCollectionViewListCell.identifier)
        collectionView.register(ItemCollectionViewGridCell.self,
                                forCellWithReuseIdentifier: ItemCollectionViewGridCell.identifier)
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

    private func setupItemManager() {
        itemManager.delegate = self
        if itemManager.items.count == 0 {
            self.itemManager.readItems()
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (collectionView.contentOffset.y * 1.2) > (collectionView.contentSize.height - collectionView.bounds.size.height) {

            if fetchingMore {
                fetchingMore = false

                self.itemManager.readItems()
            }
        }
    }
}

// - MARK: ViewControllerDelegate
@available(iOS 14.0, *)
extension ViewController: ViewControllerDelegate {
    func reloadCollectionView() {
        self.collectionView.reloadData()

        if !self.fetchingMore {
            self.fetchingMore = true
        }
    }

    func didTapViewMode() {
        self.setupCollectionViewLayout()
        self.collectionView.scrollToTop()
        self.collectionView.reloadDataCompletion {
            self.collectionView.setNeedsLayout()
        }
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
        let item = self.itemManager.items[indexPath.row]

        if rightSideView.itemViewMode == .list {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCollectionViewListCell.identifier, for: indexPath) as? ItemCollectionViewListCell else { return UICollectionViewCell() }


            cell.setupItem(item: item)

            DispatchQueue.main.async {
                cell.setupThumbnailImage(image: self.itemManager.downloadImage(index: indexPath.row))
            }

            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCollectionViewGridCell.identifier, for: indexPath) as? ItemCollectionViewGridCell else { return UICollectionViewCell() }

            cell.setupItem(item: item)

            DispatchQueue.main.async {
                cell.setupThumbnailImage(image: self.itemManager.downloadImage(index: indexPath.row))
            }

            return cell
        }

    }
}

// - MARK: UICollectionViewFlowLayout
@available(iOS 14.0, *)
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width/2.1, height: view.frame.height/3.3)
    }
}
