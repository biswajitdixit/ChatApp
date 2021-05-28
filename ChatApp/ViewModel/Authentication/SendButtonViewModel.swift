

import Foundation
struct SendButtonViewModel:AuthenticationProtocol{
    var text: String?
    
    var formIsValid: Bool{
        return text?.isEmpty == false
           
    }
}
