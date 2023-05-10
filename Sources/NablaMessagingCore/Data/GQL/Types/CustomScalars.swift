import Apollo
import Foundation

// List of custom scalar used for NablaMessagingCore resolution
extension GQL {
    typealias UUID = Foundation.UUID
    typealias ID = GraphQLID
    typealias DateTime = Date
    typealias TimeZone = String
    typealias BigDecimal = Decimal
}
