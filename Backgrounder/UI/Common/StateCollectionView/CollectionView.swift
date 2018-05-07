import UIKit

/// CollectionView is a subclass of `UICollectionView` that doesn't require you to implement `UICollectionViewDataSource` methods
/// It has a `source` property, assigning your data structure to that, the collectionView will update itself
/// If you want to update the single items that are changed
/// instead of reloading everything (will use `reloadData()` behind the scenes),
/// set the `useDiffs` property to `true` and the CollectionView will automatically take care of that
/// (using 'performBatchUpdates()' on the changes)
class CollectionView<Cell: UICollectionViewCell, S: Source>:
UICollectionView, UICollectionViewDelegateFlowLayout where Cell: ConfigurableCell, Cell.VD == S.SourceType {

    typealias IndexPathHandler = (IndexPath) -> Void
    typealias CellAndIndexPathHandler = (Cell, IndexPath) -> Void

    var customDataSource: DataSource<S, Cell>!

    var source: S? {
        set {
            // we are not updating the `customDataSource` right away in order to support `performBatchUpdates`
            // given that right before the update the system will call the `numberOfItemsInSection` method of the delegate
            // and we need to specify the oldSource count for that to work
            self.oldSource = self.customDataSource.source
            self.update(from: self.oldSource, new: newValue)
        }

        get {
            return self.customDataSource.source
        }
    }

    // old source used in the diff updates
    private var oldSource: S?

    var useDiffs: Bool

    init(frame: CGRect, layout: UICollectionViewLayout, source: S? = nil, useDiffs: Bool = false) {
        self.useDiffs = useDiffs
        super.init(frame: frame, collectionViewLayout: layout)
        self.customDataSource = DataSource<S, Cell>(collectionView: self)
        register(cellType: Cell.self)
        self.delegate = self
        self.source = source
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func update(from old: S?, new: S?) {
        guard let old = old, self.useDiffs else {
            self.customDataSource.source = new
            self.reloadData()
            return
        }

        self.customDataSource.source = new
        // we are using `performBatchUpdates` here, we will update the customDataSource only inside the callback
        // because we still need the old dataSource in the first stage od the `performBatchUpdates`
        new?.diffUpdate(for: self, old: old)
    }

    // MARK: - Interactions
    var didTapItem: IndexPathHandler?
    var willDisplayCell: CellAndIndexPathHandler?
    var didEndDisplayingCell: CellAndIndexPathHandler?

    var configureCell: ((Cell, IndexPath) -> Void)? {
        didSet {
            self.customDataSource.configureCell = self.configureCell
        }
    }

    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.didTapItem?(indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? Cell else { return }
        self.willDisplayCell?(cell, indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? Cell else { return }
        self.didEndDisplayingCell?(cell, indexPath)
    }
}
