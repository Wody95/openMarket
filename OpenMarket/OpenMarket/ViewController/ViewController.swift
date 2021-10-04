import UIKit
import SnapKit

@available(iOS 14.0, *)
class ViewController: UIViewController {

    let rightSideView = RightSideView(frame: CGRect(x: 0, y: 0, width: 70, height: 37))
    var collectionView = ItemCollectionView(frame: .zero,
                                            collectionViewLayout: UICollectionViewFlowLayout())



    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        configureCollectionView()
        setupCollectionViewList()
    }

    private func configureNavigationBar() {
        self.navigationItem.title = "Market"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightSideView)
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

    private func setupCollectionViewList() {
        let configList = UICollectionLayoutListConfiguration(appearance: .plain)
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout.list(using: configList)
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
        20
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCollectionViewCell.identifier, for: indexPath) as? ItemCollectionViewCell else { return UICollectionViewCell() }

        cell.setupTitleText(text: "test입니다")

        return cell
    }
}
