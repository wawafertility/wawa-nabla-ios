import Foundation
import NablaMessagingCore

final class DocumentMessagePresenter:
    MessagePresenter<
        DocumentMessageContentView,
        DocumentMessageViewItem,
        ConversationMessageCell<DocumentMessageContentView>
    > {
    // MARK: - Init
        
    init(
        item: DocumentMessageViewItem,
        conversationId: UUID,
        client: NablaClient,
        delegate: ConversationCellPresenterDelegate
    ) {
        super.init(
            item: item,
            conversationId: conversationId,
            client: client,
            delegate: delegate,
            transformContent: Self.transform
        )
    }
    
    override func userDidTapContent() {
        delegate?.didTapMedia(item.document)
    }
    
    // MARK: - Private
    
    private weak var delegate: ConversationCellPresenterDelegate?
    
    private static func transform(item: DocumentMessageViewItem) -> DocumentMessageContentView.ContentViewModel {
        .init(url: item.document.thumbnailUrl, filename: item.document.fileName)
    }
}