
import Firebase
import FirebaseDatabase

//struct Service {
//    static func fetchUser(completion: @escaping([User]) -> Void) {
//        var users = [User]()
//        Firestore.firestore().collection("users").getDocuments { (snapshot, error) in
//            snapshot?.documents.forEach({ document in
//               
//                let dictionary = document.data()
//                let user = User(dictionary: dictionary)
//            
//                users.append(user)
//                completion(users)
//                
//            })
//        }
//    }
//}
struct Service {
    static func fetchUser(Completion: @escaping ([User]) -> Void){
        var users = [User]()
        Database.database().reference().child("users").observe(.childAdded, with : {
            (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let user = User(dictionary: dictionary)
                user.id = snapshot.key
                users.append(user)
                Completion(users)
            }
        },withCancel: nil)
    }
}
