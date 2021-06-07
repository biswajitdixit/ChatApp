import UIKit
import SDWebImage

private let reuseIdentifier = "MessageCell"
class ChatController: UICollectionViewController {
    
    //Marks:- Properties
    
    private let user:User
    private var messages = [Message]()
    var fromCurrentUser = false
    
    private lazy var customInputView :CustomInputView = {
        let iv = CustomInputView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
        iv.delegate = self
        return iv
    }()
    
    //Marks:- LifeCycle
    init(user: User) {
        self.user = user
        super.init(collectionViewLayout : UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        fetchMessages()
        
    }
    
    override var inputAccessoryView: UIView? { 
        get{ return customInputView }
    }
    
    override var canBecomeFirstResponder: Bool{
        return true
    }
    
    //Marks:- API
    
    func fetchMessages() {
        Service.observeMessages(forUser: user) { (snapshot) in
            let messageId = snapshot.key
            Service.fetchMessages(messageId: messageId, completion: { (snapshot) in
                guard let dictionary = snapshot.value as? [String: AnyObject] else {
                    return
                }
                self.messages.append(Message(dictionary: dictionary))
                DispatchQueue.main.async(execute: {
                    self.collectionView?.reloadData()
                    self.collectionView.scrollToItem(at: [0, self.messages.count - 1], at: .bottom, animated: true)
                })
                
            })
        }
    }
    
    //Mark:- Helpers
    
    func configureUI(){
        collectionView.backgroundColor = .white
        configureNavigationBar(withTitle: user.userName!, prefersLargeTitles: false)
        collectionView.register(MessageCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.alwaysBounceVertical = true
        NotificationCenter.default.addObserver(self, selector: #selector(notificationRecived), name: Notification.Name("sendImage"), object: nil)
        
        
    }
    
    //Mark:-Selectors
    @objc  func notificationRecived() {
        handleUploadTap()
        
    }
    
}

extension ChatController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MessageCell
        cell.zoomDelegate = self
        cell.message = messages[indexPath.row]
        cell.message?.user = user
        let messageImageUrl = cell.message?.imageUrl ?? ""
        let url = URL(string: messageImageUrl)
        cell.messageImageView.sd_setImage(with: url)
        return cell
    }
}


extension ChatController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 0, bottom: 16, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let estimateSizeCell = MessageCell(frame: frame)
        estimateSizeCell.message = messages[indexPath.row]
        estimateSizeCell.layoutIfNeeded()
        
        var height: CGFloat = 80
        
        if let imageWidth = estimateSizeCell.message?.imageWidth?.floatValue, let imageHeight = estimateSizeCell.message?.imageHeight?.floatValue {
            height = CGFloat(imageHeight / imageWidth * 200)
            
        }else{
            let targetSize = CGSize(width: view.frame.width, height: 1000)
            let estimatedSize = estimateSizeCell.systemLayoutSizeFitting(targetSize)
            return .init(width: view.frame.width, height: estimatedSize.height)
        }
        let width = UIScreen.main.bounds.width
        return CGSize(width: width, height: height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}


extension ChatController: CustomInputAccessoryViewDelegate , UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func inputView(_ inputView: CustomInputView, wantsToSend message: String) {
        Service.sendMessage(inputTextField: inputView.messageInputTextView.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines), id: user.id!, completion: {
            (error, ref) in
            if error != nil {
                print(error!)
                return
            }
            
            inputView.messageInputTextView.text = nil
            guard let messageId = ref.key else { return }
            Service.senderReciptanatMessage( messageId: messageId, toId: self.user.id!)
        })
    }
    
    
    func handleUploadTap() {
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerOriginalImage")] as? UIImage {
            
            selectedImageFromPicker = originalImage
        }
        
        
        if let selectedImage = selectedImageFromPicker {
            Service.uploadImageMessageToFirebase(selectedImage,completion: { (imageUrl) in
                Service.sendImage(imageUrl, image: selectedImage,id: self.user.id!, completion: {
                    (error, ref) in
                    if error != nil {
                        print(error!)
                        return
                    }
                    guard let messageId = ref.key else { return }
                    Service.senderReciptanatMessage( messageId: messageId, toId: self.user.id!)
                })
            }
            
            )}
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension ChatController:ImageZoomDelegate {
    func customView(alphaValue: Int) {
        customInputView.alpha = CGFloat(alphaValue)
    }
    
    
}
