import Foundation

protocol DeleteMessageInteractor {
    func execute(
        messageId: UUID,
        conversationId: UUID,
        handler: ResultHandler<Void, NablaDeleteMessageError>
    ) -> Cancellable
}
