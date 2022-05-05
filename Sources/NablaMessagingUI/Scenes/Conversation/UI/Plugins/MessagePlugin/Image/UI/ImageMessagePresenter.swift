import Foundation
import NablaMessagingCore

final class ImageMessagePresenter:
    MessagePresenter<
        ImageMessageContentView,
        ImageMessageViewItem,
        ConversationMessageCell<ImageMessageContentView>
    > {
    // MARK: - Init
    
    init(
        item: ImageMessageViewItem,
        conversationId: UUID,
        client: NablaClient,
        delegate: ConversationCellPresenterDelegate
    ) {
        self.delegate = delegate
        super.init(
            item: item,
            conversationId: conversationId,
            client: client,
            delegate: delegate,
            transformContent: Self.transform
        )
    }
    
    override func userDidTapContent() {
        delegate?.didTapMedia(item.image)
    }
    
    // MARK: - Private
    
    private weak var delegate: ConversationCellPresenterDelegate?
    
    // TODO: - Move the transform to a separate class ?
    private static func transform(item: ImageMessageViewItem) -> ImageMessageContentView.ContentViewModel {
        .init(url: item.image.fileUrl)
    }
}