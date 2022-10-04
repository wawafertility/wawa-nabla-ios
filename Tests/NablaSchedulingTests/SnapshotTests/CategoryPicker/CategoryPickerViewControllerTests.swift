import Combine
import NablaCore
@testable import NablaScheduling
import SnapshotTesting
import XCTest

class CategoryPickerViewControllerTests: XCTestCase {
    private var sut: CategoryPickerViewController!
    
    private var viewModel: CategoryPickerViewModelMock!
    private var navigationController: UINavigationController!

    override func setUp() {
        super.setUp()
        viewModel = .init()
        sut = CategoryPickerViewController(viewModel: viewModel)
        navigationController = UINavigationController(rootViewController: sut)
        navigationController.navigationBar.prefersLargeTitles = true
        
        viewModel.given(.onChange(willReturn: Just(()).eraseToAnyPublisher()))
        viewModel.given(.onChange(throttle: .any, willReturn: Just(()).eraseToAnyPublisher()))
    }

    func testCategoryPickerViewControllerWithItems() {
        // GIVEN
        viewModel.given(.isLoading(getter: false))
        viewModel.given(.items(getter: (0 ... 20).map { index in
            .init(id: .init(), title: "Category \(index)")
        }))
        // WHEN
        // THEN
        assertSnapshot(matching: navigationController, as: .image)
    }
    
    func testCategoryPickerViewControllerEmptyView() {
        // GIVEN
        viewModel.given(.isLoading(getter: false))
        viewModel.given(.items(getter: []))
        // WHEN
        // THEN
        assertSnapshot(matching: navigationController, as: .image)
    }
    
    func testCategoryPickerViewControllerLoading() {
        // GIVEN
        viewModel.given(.isLoading(getter: true))
        viewModel.given(.items(getter: []))
        // WHEN
        // THEN
        assertSnapshot(matching: navigationController, as: .image)
    }
    
    func testCategoryPickerViewControllerWithBigItems() {
        // GIVEN
        viewModel.given(.isLoading(getter: false))
        viewModel.given(.items(getter: (0 ... 20).map { index in
            .init(id: .init(), title: Array(repeating: "Category", count: index).joined(separator: " "))
        }))
        // WHEN
        // THEN
        assertSnapshot(matching: navigationController, as: .image)
    }
}