
import Foundation

struct ConversationviewModel {
    
    private let conversation: Message
    var timeStamp: String {
        let date = conversation.timeStamp?.doubleValue
        let timestampDate = Date(timeIntervalSince1970: date!)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:ss a"
        return dateFormatter.string(from: timestampDate)
        
    }
    
    init(conversation: Message) {
        self.conversation = conversation
    }
}

