
import Foundation
protocol AuthenticationProtocol {
    var formIsValid: Bool {get}
}
struct RegistrationViewModel:AuthenticationProtocol {
    var email: String?
    var fullName: String?
    var userName: String?
    var password: String?
    
    var formIsValid: Bool{
        return email?.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty == false
            &&  password?.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty == false
            &&  fullName?.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty == false
            &&  userName?.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty == false
    }
}
