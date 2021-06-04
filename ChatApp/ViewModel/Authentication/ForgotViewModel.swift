
import Foundation
struct ForgotViewModel:AuthenticationProtocol{
    var email: String?
    
    var formIsValid: Bool{
        return email?.isEmpty == false
        
    }
}
