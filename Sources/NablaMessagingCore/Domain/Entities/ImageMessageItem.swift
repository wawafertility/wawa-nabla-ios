import Foundation

public struct ImageMessageItem: ConversationItem {
    public let id: UUID
    public let date: Date
    public let sender: ConversationItemSender
    public let state: ConversationItemState
    public let content: Media
}