import UIKit
import Firebase

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
        
        print("user is \(user.userName)")
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
          
            let messagesRef = Database.database().reference().child("messages").child(messageId)
            messagesRef.observeSingleEvent(of: .value, with: { (snapshot) in

                guard let dictionary = snapshot.value as? [String: AnyObject] else {
                    return
                }
                self.messages.append(Message(dictionary: dictionary))
                
                self.collectionView.reloadData()
                self.collectionView.scrollToItem(at: [0, self.messages.count - 1], at: .bottom, animated: true)
                })

            }
    }
             
    //Mark:- Helpers
    
    func configureUI(){
        collectionView.backgroundColor = .white
        configureNavigationBar(withTitle: user.userName!, prefersLargeTitles: false)
        collectionView.register(MessageCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.alwaysBounceVertical = true
    
    }
    
}


extension ChatController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MessageCell
        cell.message = messages[indexPath.row]
        cell.message?.user = user
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
        
        let targetSize = CGSize(width: view.frame.width, height: 1000)
        let estimatedSize = estimateSizeCell.systemLayoutSizeFitting(targetSize)
        return .init(width: view.frame.width, height: estimatedSize.height)
    }
}


extension ChatController: CustomInputAccessoryViewDelegate {
    func inputView(_ inputView: CustomInputView, wantsToSend message: String) {
        Service.sendMessage(inputTextField: inputView.messageInputTextView.text, id: user.id!, completion: {
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
    
    
}
