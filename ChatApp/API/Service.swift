
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
    
    static func sendMessage(inputTextField:String, id:String , completion: @escaping ((Error?, DatabaseReference) -> Void)){
        let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let toId = id
        let fromId = Auth.auth().currentUser!.uid
        let timestamp = Int(Date().timeIntervalSince1970)
        let values = ["text": inputTextField, "toId": toId, "fromId": fromId, "timestamp": timestamp] as [String : Any]
        
        childRef.updateChildValues(values,withCompletionBlock: completion )
        
        }
    
    
    static func sendImage(_ imageUrl: String,image: UIImage, id:String,completion: @escaping ((Error?, DatabaseReference) -> Void)){
        let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let toId = id
        let fromId = Auth.auth().currentUser!.uid
        let timestamp = Int(Date().timeIntervalSince1970)
        
        let values = ["imageUrl": imageUrl, "toId": toId, "fromId": fromId, "timestamp": timestamp,"imageWidth": image.size.width as AnyObject, "imageHeight": image.size.height ] as [String : Any]
        childRef.updateChildValues(values,withCompletionBlock: completion )
        
    }
    
    static func senderReciptanatMessage( messageId:String, toId: String) {
        let fromId = Auth.auth().currentUser!.uid
        let userMessagesRef = Database.database().reference().child("user-messages").child(fromId).child(toId).child(messageId)
        userMessagesRef.setValue(1)
        
        let recipientUserMessagesRef = Database.database().reference().child("user-messages").child(toId).child(fromId).child(messageId)
        recipientUserMessagesRef.setValue(1)
    }
    
    static func observeMessages(forUser user:User,completion:@escaping ((DataSnapshot) -> Void)) {
        guard let uid = Auth.auth().currentUser?.uid, let toId = user.id  else {
            return
        }
        let userMessagesRef = Database.database().reference().child("user-messages").child(uid).child(toId)
        userMessagesRef.observe(.childAdded, with: completion)
    }
    
    static func uploadImageMessageToFirebase(_ image: UIImage, completion: @escaping (_ imageUrl: String) -> ()) {
        let imageName = UUID().uuidString
        let ref = Storage.storage().reference().child("message_images").child(imageName)
        
        if let uploadData = image.jpegData(compressionQuality: 0.2) {
            ref.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                
                if error != nil {
                    print("Failed to upload image:", error!)
                    return
                }
                
                ref.downloadURL(completion: { (url, err) in
                    if let err = err {
                        print(err)
                        return
                    }
                    
                    completion(url?.absoluteString ?? "")
                })
                
            })
        }
    }
    
}
