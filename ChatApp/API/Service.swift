
import Firebase
import FirebaseDatabase


struct Service {
    static func fetchUser(Completion: @escaping ([User]) -> Void){
        var users = [User]()
        Database.database().reference().child("users").observe(.childAdded, with : {
            (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let user = User(dictionary: dictionary)
                user.id = snapshot.key
                if user.id != Auth.auth().currentUser?.uid {
                    users.append(user)
                }
                   
                
                Completion(users)
            }
        },withCancel: nil)
    }
}
