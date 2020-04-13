import GetStream
import GetStreamActivityFeed

final class FeedItem: EnrichedActivity<GetStream.User, String, DefaultReaction>, Identifiable {
    private enum CodingKeys: String, CodingKey {
        case message
    }
    
    var message: String
    
    init(actor: GetStream.User, verb: Verb, object: ObjectType, message: String) {
        self.message = message
        super.init(actor: actor, verb: verb, object: object)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        message = try container.decode(String.self, forKey: .message)
        try super.init(from: decoder)
    }
    
    required init(actor: ActorType, verb: Verb, object: ObjectType, foreignId: String? = nil, time: Date? = nil, feedIds: FeedIds? = nil, originFeedId: FeedId? = nil) {
        fatalError("init(actor:verb:object:foreignId:time:feedIds:originFeedId:) has not been implemented")
    }
    
    override public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(message, forKey: .message)
        try super.encode(to: encoder)
    }
}
