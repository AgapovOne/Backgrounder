import Reusable

// a configurableCell is a ReusableCell that can be configured with an object T and the indexPath
// this will be used when it's time to load the cell content
protocol ConfigurableCell: Reusable {
    associatedtype VD: CellViewData

    var data: VD? { get set }
}

protocol CellViewData {}
