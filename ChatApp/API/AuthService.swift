import Firebase
struct RegistrationCredential{
    let email: String
    let password: String
    let profileImage:UIImage
    let fullName:String
    let userName:String
}
struct AuthService {
    static let shared = AuthService()
    
    func logUserIn(withEmail email: String, password: String, completion: AuthDataResultCallback?){
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    func createUserIn(credential:RegistrationCredential , completion: ((Error?) -> Void)?){
      guard let imageData = credential.profileImage.jpegData(compressionQuality: 0.3) else {return}
        
        let fileName = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath: "/profile_images/\(fileName)")
        
        ref.putData(imageData, metadata: nil) { (meta, error) in
            if let error = error {
                completion!(error)
                return
            }
            ref.downloadURL { (url, error) in
                guard let profileImageUrl = url?.absoluteString else {return}
                
                
                Auth.auth().createUser(withEmail: credential.email, password: credential.password) { (result, error) in
                    if let error = error{
                        completion!(error)
                        return
                    }
                    
                    guard let uid = result?.user.uid else{return}
                    
                    let data = ["email": credential.email,
                                "fullName": credential.fullName,
                                "profileImageUrl": profileImageUrl,
                                "uid": uid,
                                "userName":credential.userName] as [String : Any]
                    
                    Firestore.firestore().collection("users").document(uid).setData(data,completion: completion)
                       
                        
                    
                    
                    
                }
            }
        }
    }
}
