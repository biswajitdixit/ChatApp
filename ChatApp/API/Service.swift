
import Firebase

struct Service {
    static func fetchUser() {
        Firestore.firestore().collection("users").getDocuments { (snapshot, error) in
            snapshot?.documents.forEach({ document in
               
            })
        }
    }
}
