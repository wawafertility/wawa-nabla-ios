import Foundation
import NablaCore

final class CreateConversationInteractorImpl: AuthenticatedInteractor, CreateConversationInteractor {
    // MARK: - Initializer

    init(authenticator: Authenticator, repository: ConversationRepository) {
        self.repository = repository
        super.init(authenticator: authenticator)
    }

    // MARK: - Internal
    
    func execute(
        title: String?,
        providerIdToAssign: UUID?,
        handler: ResultHandler<Conversation, NablaError>
    ) -> Cancellable {
        guard isAuthenticated(handler: handler) else {
            return Failure()
        }
        return repository.createConversation(
            title: title,
            providerIdToAssign: providerIdToAssign,
            handler: handler
        )
    }
    
    // MARK: - Private
    
    private let repository: ConversationRepository
}
