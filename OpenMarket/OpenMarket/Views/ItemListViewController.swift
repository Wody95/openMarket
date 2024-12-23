import UIKit
import SnapKit

@available(iOS 14.0, *)
class ItemListViewController: UIViewController {
    private let itemManager = ItemManager(urlsession: URLSessionProvider())
    private let rightSideView = RightSideView(frame: CGRect(x: 0, y: 0, width: 70, height: 37))
    private var collectionView = ItemCollectionView(frame: .zero,
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
        itemManager.setupItemManager()
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (collectionView.contentOffset.y) > (collectionView.contentSize.height - collectionView.frame.size.height) {

            if fetchingMore {
                fetchingMore = false

                self.itemManager.readItems(completion: nil)
            }
        }
    }
}

// - MARK: ViewControllerDelegate
protocol ItemListViewControllerDelegate {
    func reloadCollectionView()
    func didTapViewMode()
    func didTapAddItemButton()
    func updataItems(completion: (() -> Void)?)
}

@available(iOS 14.0, *)
extension ItemListViewController: ItemListViewControllerDelegate {
    func reloadCollectionView() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }

        if !self.fetchingMore {
            self.fetchingMore = true
        }
    }

    func didTapViewMode() {
        self.setupCollectionViewLayout()
        self.collectionView.scrollToTop()

        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }

    func didTapAddItemButton() {
        let registryItemViewController = RegistryItemViewController()
        registryItemViewController.delegate = self
        self.navigationController?.pushViewController(registryItemViewController, animated: true)
    }

    func updataItems(completion: (()-> Void)? = nil) {
        DispatchQueue.main.async {
            self.collectionView.scrollToTop()
            self.itemManager.updateItems {
                self.collectionView.reloadData()
                completion?()
            }
        }
    }
}

// - MARK: UICollectionViewDelegate
@available(iOS 14.0, *)
extension ItemListViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailItemViewController = DetailItemViewController()
        detailItemViewController.delegate = self

        itemManager.urlsessionProvider.getItem(id: itemManager.items[indexPath.row].id) { result in
            switch result{
            case .success(let data):
                guard let item = try? JSONDecoder().decode(ResponseItem.self, from: data) else { return }

                detailItemViewController.updateItem(item: item)
            case .failure(let error):
                print(error)
            }
        }

        navigationController?.pushViewController(detailItemViewController, animated: true)
    }
}

// - MARK: UICollecdtionViewDataSource
@available(iOS 14.0, *)
extension ItemListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return self.itemManager.items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = self.itemManager.items[indexPath.row]

        if rightSideView.itemViewMode == .list {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCollectionViewListCell.identifier, for: indexPath) as? ItemCollectionViewListCell else { return UICollectionViewCell() }


            cell.setupItem(item: item)

            DispatchQueue.main.async {
                self.itemManager.downloadImage(index: indexPath.row) { image in
                    cell.setupThumbnailImage(image: image)
                }
            }

            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCollectionViewGridCell.identifier, for: indexPath) as? ItemCollectionViewGridCell else { return UICollectionViewCell() }

            cell.setupItem(item: item)

            DispatchQueue.main.async {
                self.itemManager.downloadImage(index: indexPath.row) { image in
                    cell.setupThumbnailImage(image: image)
                }
            }

            return cell
        }

    }
}

// - MARK: UICollectionViewFlowLayout
@available(iOS 14.0, *)
extension ItemListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width/2.1, height: view.frame.height/3.3)
    }
}
