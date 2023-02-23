import Combine
import Foundation

private enum Constants {
    static let defaultName = "singleton"
}

/// You should always call``NablaClient.initialize`` as soon as possible.
/// Before any interaction with messaging features make sure you
/// successfully authenticated your user by calling ``NablaClient.shared.authenticate(provider:)``.
public class NablaClient {
    // MARK: - Initializer

    /// Create an instance of NablaClient to use.
    /// - Parameters:
    ///   - modules: list of modules to be used by the SDK.
    ///   - configuration: ``Configuration`` containing the APIKey and some defaults you can override.
    ///   - networkConfiguration: optional network configuration, exposed for internal tests purposes and should not be used in your app.
    ///   - name: Namespace for your the stored objects.
    public convenience init(
        modules: [Module],
        configuration: Configuration,
        networkConfiguration: NetworkConfiguration? = nil,
        name: String
    ) {
        let networkConfiguration = networkConfiguration ?? DefaultNetworkConfiguration()
        let container = CoreContainer(
            name: name,
            configuration: configuration,
            networkConfiguration: networkConfiguration,
            modules: modules
        )
        self.init(apiKey: configuration.apiKey, container: container)
    }
    
    /// Internal use only
    init(apiKey: String, container: CoreContainer) {
        self.container = container
        addHTTPHeader(name: HTTPHeaders.NablaApiKey, value: Self.formatApiKey(apiKey))
    }

    // MARK: - Public

    /// Shared instance of NablaClient client to use.
    /// Always call ``NablaClient.initialize`` before accessing it.
    public static var shared: NablaClient {
        guard let shared = _shared else {
            fatalError("NablaClient.initialize() must be called before accessing NablaClient.shared")
        }
        return shared
    }

    /// Shared instance initializer, you must call this method before accessing `NablaClient.shared`.
    /// You must call this method only once.
    /// - Parameters:
    ///   - modules: list of modules to be used by the SDK.
    ///   - configuration: ``Configuration`` containing the APIKey and some defaults you can override.
    ///   - networkConfiguration: optional network configuration, exposed for internal tests purposes and should not be used in your app.
    public static func initialize(
        modules: [Module],
        configuration: Configuration,
        networkConfiguration: NetworkConfiguration? = nil
    ) {
        guard _shared == nil else {
            configuration.logger.warning(message: "NablaClient.initialize() should only be called once. Ignoring this call and using the previously created shared instance.")
            return
        }
        _shared = NablaClient(
            modules: modules,
            configuration: configuration,
            networkConfiguration: networkConfiguration,
            name: Constants.defaultName
        )
    }

    /// Authenticate the current user.
    /// - Parameters:
    ///   - userId: Identifies the user between sessions, will be passed when calling the ``SessionTokenProvider``.
    ///   - provider: ``Tokens`` provider.
    public func setCurrentUser(userId: String) throws {
        container.authenticator.authenticate(userId: userId)
        
        if let previousUser = container.userRepository.getCurrentUser() {
            if previousUser.id == userId {
                container.logger.info(message: "Setting the same current user again, ignoring.")
                return
            } else {
                container.logger.error(message: "Trying to authenticating a new user, should clear previous one first by calling `clearCurrentUser`.")
                throw CurrentUserAlreadySetError()
            }
        }
        container.logger.info(message: "Setting a new current user.")
        container.userRepository.setCurrentUser(User(id: userId))
        
        Task(priority: .background) {
            await container.registerDeviceInteractor.execute(userId: userId)
        }
    }
    
    public var currentUserId: String? {
        container.userRepository.getCurrentUser()?.id
    }

    /// Clears all data linked to the current userId in memory and on disk
    public func clearCurrentUser() async {
        await container.logOutInteractor.execute()
    }
    
    /// Watch the state of the events connection the SDK is using to receive live updates (new messages, new appointments etc...)
    ///
    /// You can use this to display a message to the user indicating they are offline if your use case
    /// is time sensitive and the risk of missing a message is important.
    ///
    /// Note that when the SDK is initialized, it starts with ``EventsConnectionState.notConnected``.
    /// The state will get updated when calling ``NablaClient.authenticate(userId:provider:)``.
    ///
    public func watchEventsConnectionState() -> AnyPublisher<EventsConnectionState, Never> {
        container.webSocketTransport.observeConnectionState()
    }

    /// Add default HTTP Headers to calls. This is for internal usage and you should probably never call it.
    /// - Parameters:
    ///   - name: The name of the header
    ///   - value: The value of the header
    public func addHTTPHeader(name: String, value: String) {
        container.extraHeaders.set(value, for: name)
    }
    
    /// Any ``RefetchTrigger`` will tell the SDK to update watchers with the latest server data.
    /// It is a common practice to add some ``NotificationRefetchTrigger(name: UIApplication.willEnterForegroundNotification)``
    /// in order to refresh the on screen information when your application comes back to foreground
    /// - Parameter triggers: The triggers to add.
    public func addRefetchTriggers(_ triggers: RefetchTrigger...) {
        container.gqlClient.addRefetchTriggers(triggers)
    }
    
    /// Internal use only.
    public private(set) var container: CoreContainer

    // MARK: - Private
    
    private static var _shared: NablaClient?
    
    private static func formatApiKey(_ apiKey: String) -> String {
        apiKey.replacingOccurrences(of: "Authorization: Bearer ", with: "")
    }
}
