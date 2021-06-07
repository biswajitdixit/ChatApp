
import Foundation
struct ForgotViewModel:AuthenticationProtocol{
    var email: String?
    
    var formIsValid: Bool{
        return email?.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty == false
        
    }
}
