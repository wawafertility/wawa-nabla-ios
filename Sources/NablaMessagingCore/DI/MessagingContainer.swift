import Foundation
import NablaCore

class MessagingContainer {
    // MARK: - Initializer

    init(coreContainer: CoreContainer) {
        self.coreContainer = coreContainer
    }

    // MARK: - Internal
    
    var logger: Logger {
        coreContainer.logger
    }
    
    var gqlClient: GQLClient {
        coreContainer.gqlClient
    }

    private(set) lazy var createConversationInteractor: CreateConversationInteractor = CreateConversationInteractorImpl(
        authenticator: coreContainer.authenticator,
        repository: conversationRepository
    )
    
    private(set) lazy var createDraftConversationInteractor: CreateDraftConversationInteractor = CreateDraftConversationInteractorImpl(
        repository: conversationRepository
    )

    private(set) lazy var watchConversationItemsInteractor: WatchConversationItemsInteractor = WatchConversationItemsInteractorImpl(
        authenticator: coreContainer.authenticator,
        itemsRepository: conversationItemRepository,
        conversationsRepository: conversationRepository
    )

    private(set) lazy var sendMessageInteractor: SendMessageInteractor = SendMessageInteractorImpl(
        authenticator: coreContainer.authenticator,
        itemsRepository: conversationItemRepository,
        conversationsRepository: conversationRepository
    )

    private(set) lazy var retrySendingMessageInteractor: RetrySendingMessageInteractor = RetrySendingMessageInteractorImpl(
        authenticator: coreContainer.authenticator,
        itemsRepository: conversationItemRepository,
        conversationsRepository: conversationRepository
    )

    private(set) lazy var deleteMessageInteractor: DeleteMessageInteractor = DeleteMessageInteractorImpl(
        authenticator: coreContainer.authenticator,
        itemsRepository: conversationItemRepository,
        conversationsRepository: conversationRepository
    )

    private(set) lazy var setIsTypingInteractor: SetIsTypingInteractor = SetIsTypingInteractorImpl(
        authenticator: coreContainer.authenticator,
        repository: conversationRepository
    )

    private(set) lazy var markConversationAsSeenInteractor: MarkConversationAsSeenInteractor = MarkConversationAsSeenInteractorImpl(
        authenticator: coreContainer.authenticator,
        repository: conversationRepository
    )

    private(set) lazy var watchConversationsInteractor: WatchConversationsInteractor = WatchConversationsInteractorImpl(
        authenticator: coreContainer.authenticator,
        repository: conversationRepository
    )

    private(set) lazy var watchConversationInteractor: WatchConversationInteractor = WatchConversationInteractorImpl(
        authenticator: coreContainer.authenticator,
        repository: conversationRepository
    )

    // MARK: - Private
    
    private let coreContainer: CoreContainer

    private lazy var conversationRepository: ConversationRepository = ConversationRepositoryImpl(
        remoteDataSource: conversationRemoteDataSource,
        localDataSource: conversationLocalDataSource
    )

    private lazy var conversationItemRepository: ConversationItemRepository = ConversationItemRepositoryImpl(
        itemsRemoteDataSource: conversationItemRemoteDataSource,
        itemsLocalDataSource: conversationItemLocalDataSource,
        fileUploadRemoteDataSource: fileUploadRemoteDataSource,
        conversationLocalDataSource: conversationLocalDataSource,
        conversationRemoteDataSource: conversationRemoteDataSource,
        uploadClient: coreContainer.uploadClient,
        logger: coreContainer.logger
    )
    
    private lazy var conversationLocalDataSource: ConversationLocalDataSource = ConversationLocalDataSourceImpl()

    private lazy var conversationRemoteDataSource: ConversationRemoteDataSource = ConversationRemoteDataSourceImpl(
        gqlClient: coreContainer.gqlClient,
        gqlStore: coreContainer.gqlStore
    )

    private lazy var conversationItemRemoteDataSource: ConversationItemRemoteDataSource = ConversationItemRemoteDataSourceImpl(
        gqlClient: coreContainer.gqlClient,
        gqlStore: coreContainer.gqlStore,
        logger: coreContainer.logger
    )

    private lazy var conversationItemLocalDataSource: ConversationItemLocalDataSource = ConversationItemLocalDataSourceImpl()

    private lazy var fileUploadRemoteDataSource: FileUploadRemoteDataSource = FileUploadRemoteDataSourceImpl(uploadClient: coreContainer.uploadClient)
}
