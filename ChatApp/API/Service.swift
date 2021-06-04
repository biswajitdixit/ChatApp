
import Firebase
import FirebaseDatabase


struct Service {
    
    //Marks:-Authentication
    
    static func registerUser(email:String,password:String,_ completion:@escaping ((AuthDataResult?, Error?) -> Void)){
        
        Auth.auth().createUser(withEmail: email, password: password, completion: completion )
        
    }
    
    static func Login(email:String, password:String,_ completion:@escaping ((AuthDataResult?, Error?) -> Void)){
        Auth.auth().signIn(withEmail: email, password: password,completion: completion)
    }
    
    static func forgotPassword(email:String, completion:@escaping((Error?)->Void)){
        Auth.auth().sendPasswordReset(withEmail: email,completion: completion)
    }
    
    static func currentUser() -> String  {
        guard let uid = Auth.auth().currentUser?.uid else {return "no id"}
        return uid
    }
   
    //Marks:- Database
    
    static func updteInDatabase(_ uid: String, values: [String: AnyObject]) {
        let ref = Database.database().reference()
        let usersReference = ref.child("users").child(uid)
        
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            
            if let err = err {
                print(err.localizedDescription)
                
                return
            }
            
        })
    }
    
    static func uploadImage(profileImage:UIImage,completion:@escaping ((URL?,Error?)->Void) ){
        
        let imageName = UUID().uuidString
        let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).png")
        
        if let uploadData = profileImage.pngData() {
            
            storageRef.putData(uploadData, metadata: nil,  completion: { (_, err) in
                
                storageRef.downloadURL(completion: completion)
                
            })
        }
    }
    
    
    static func fetchUsers(Completion: @escaping ([User]) -> Void){
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
    
    
    static func fetchUsernameAndImage(id:String,_ completion:@escaping ((DataSnapshot) -> Void)){
        let ref = Database.database().reference().child("users").child(id)
        ref.observeSingleEvent(of: .value, with:completion)
    }
    
    
    static func currentMessage(completion: @escaping ((DataSnapshot) -> Void)){
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let ref = Database.database().reference().child("user-messages").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            
            let userId = snapshot.key
            Database.database().reference().child("user-messages").child(uid).child(userId).observe(.childAdded, with: completion)
            
        }, withCancel: nil)
    }
    
    
    static func currentMessagewithId(_ messageId: String, completion:  @escaping ((DataSnapshot) -> Void)){
        let messagesReference = Database.database().reference().child("messages").child(messageId)
        
        messagesReference.observeSingleEvent(of: .value, with: completion)
    }
    
    
    static func getUser(withUid uid:String, Completion: @escaping (User) ->Void){
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let user = User(dictionary: dictionary)
                Completion(user)
            }
        })
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
    
    static func navigateTomessenger(chatPartnerId:String,completion:@escaping ((DataSnapshot)-> Void)){
        let ref = Database.database().reference().child("users").child(chatPartnerId)
        ref.observeSingleEvent(of: .value, with: completion)
    }
    
    static func deleteMessage(chatPartnerId:String, completion:@escaping (Error?,DatabaseReference)-> Void){
        let uid = currentUser()
        Database.database().reference().child("user-messages").child(uid).child(chatPartnerId).removeValue(completionBlock: completion)
    }
    
    
}
