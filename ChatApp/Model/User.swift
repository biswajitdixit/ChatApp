
import UIKit

class User: NSObject {
    var id: String?
    var fullName: String?
    var userName: String?
    var email: String?
    var profileImageUrl: String?
    init(dictionary: [String: AnyObject]) {
        self.id = dictionary["id"] as? String
        self.email = dictionary["email"] as? String
        self.fullName = dictionary["fullName"] as? String
        self.profileImageUrl = dictionary["profileImageUrl"] as? String
        self.userName = dictionary["userName"] as? String
        
        
    }
}
