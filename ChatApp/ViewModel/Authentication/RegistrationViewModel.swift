
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
        return email?.isEmpty == false
            &&  password?.isEmpty == false
            &&  fullName?.isEmpty == false
            &&  userName?.isEmpty == false
    }
}
