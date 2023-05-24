import Foundation

class EnvironmentImpl: Environment {
    let platform = "ios"
    let version = "1.1.3"
    
    var serverUrl: URL {
        return networkConfiguration.baseUrl
//        var components = URLComponents()
//        components.host = networkConfiguration.domain
//        components.scheme = networkConfiguration.scheme
//        components.port = networkConfiguration.port
//        components.path = networkConfiguration.path
//        // swiftlint:disable:next force_unwrapping
//        return components.url!
    }
    
    var graphqlPath: String {
        "v1/patient/graphql/sdk/authenticated"
    }
    
    var graphqlHttpUrl: URL {
        serverUrl.appendingPathComponent(graphqlPath)
    }
    
    var graphqlWebSocketUrl: URL {
//        var components = URLComponents()
//        components.host = networkConfiguration.domain
//        components.scheme = networkConfiguration.scheme == "https" ? "wss" : "ws"
//        components.port = networkConfiguration.port
//        components.path = networkConfiguration.path
//        // swiftlint:disable:next force_unwrapping
//        return components.url!.appendingPathComponent(graphqlPath)
        return networkConfiguration.webSocketUrl ??  networkConfiguration.baseUrl.appendingPathComponent(graphqlPath)
    }
    
    var languageCode: String {
        Locale.current.languageCode ?? "en"
    }
    
    init(
        networkConfiguration: NetworkConfiguration
    ) {
        self.networkConfiguration = networkConfiguration
    }
    
    // MARK: - Private
    
    private let networkConfiguration: NetworkConfiguration
}
