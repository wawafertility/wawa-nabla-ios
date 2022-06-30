import Foundation
import NablaCore
import NablaMessagingCore
import UIKit

final class VideoMessageCellProvider: ConversationCellProvider {
    // MARK: Initializer
    
    init(
        logger: Logger,
        conversationId: UUID,
        client: NablaMessagingClientProtocol
    ) {
        self.logger = logger
        self.conversationId = conversationId
        self.client = client
    }
    
    // MARK: - Public
    
    func prepare(collectionView: UICollectionView) {
        collectionView.register(Cell.self)
    }
    
    func provideCell(
        collectionView: UICollectionView,
        indexPath: IndexPath,
        item: ConversationViewItem,
        delegate: ConversationCellPresenterDelegate
    ) -> UICollectionViewCell? {
        guard let item = item as? VideoMessageViewItem else {
            return nil
        }
        
        let cell = collectionView.dequeueReusableCell(ofClass: Cell.self, for: indexPath)
        let presenter = findOrCreatePresenter(
            item: item,
            delegate: delegate
        )
        presenter.attachView(cell)
        cell.configure(presenter: presenter)
        return cell
    }
    
    // MARK: - Private
    
    private typealias Cell = ConversationMessageCell<VideoMessageContentView>
    
    private let client: NablaMessagingClientProtocol
    private let logger: Logger
    private let conversationId: UUID
    
    private var presenters: [UUID: VideoMessagePresenter] = [:]
    
    private func findOrCreatePresenter(
        item: VideoMessageViewItem,
        delegate: ConversationCellPresenterDelegate
    ) -> VideoMessagePresenter {
        if let presenter = presenters[item.id] {
            presenter.item = item
            return presenter
        } else {
            let presenter = VideoMessagePresenter(
                logger: logger,
                item: item,
                conversationId: conversationId,
                client: client,
                delegate: delegate
            )
            presenters[item.id] = presenter
            return presenter
        }
    }
}
