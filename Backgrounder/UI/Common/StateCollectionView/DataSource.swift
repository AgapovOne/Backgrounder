import UIKit

// this class is implementing all the common methods of the UICollectionViewDataSource
// (like numberOfSections, numberOfItemsInSection, cellForItemAt) automatically,
// you can extend this class if you want to provide an implementation for all the other methods of UICollectionViewDataSource
// note that you still need to trigger reloadData() yourself
// if you are looking for a way to automatize the reloadData() or performBatchUpdates() when the data changes,
// look at the CollectionView class

class DataSource<S: Source, Cell: UICollectionViewCell>: NSObject,
UICollectionViewDataSource where Cell: ConfigurableCell, Cell.VD == S.SourceType {

    var source: S?

    var configureCell: ((Cell, IndexPath) -> Void)?

    unowned var collectionView: UICollectionView

    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init()
        collectionView.dataSource = self
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.source?.numberOfSections() ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.source?.numberOfRows(section: section) ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: Cell = collectionView.dequeueReusableCell(for: indexPath)

        self.configureCell?(cell, indexPath)

        return cell
    }

    func item(at indexPath: IndexPath) -> S.SourceType? {
        guard indexPath.section >= 0,
            indexPath.row >= 0 else {
                return nil
        }
        return self.source?.data(section: indexPath.section, row: indexPath.row)
    }

}
