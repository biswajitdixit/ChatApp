
import Foundation

struct LoginViewModel:AuthenticationProtocol{
    var email: String?
    var password: String?
    
    var formIsValid: Bool{
        
        return email?.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty == false
            &&  password?.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty == false
    }
}
