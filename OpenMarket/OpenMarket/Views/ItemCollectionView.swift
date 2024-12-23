import UIKit

class ItemCollectionView: UICollectionView {

    func scrollToTop() {
        let topIndex = IndexPath(row: 0, section: 0)

        self.scrollToItem(at: topIndex, at: .top, animated: false)
    }

    func reloadDataCompletion(completion: @escaping () -> Void) {
        super.reloadData()
    }
}
