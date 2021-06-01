
import UIKit
import Firebase

private let reuseIdentifier = "ConversationCell"
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}

class ConvesationController:UIViewController{
   
    //Mark: - Properties
    private let tableView = UITableView()
    private let messageButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "bubble.right.fill"), for: .normal)
        button.backgroundColor = .systemPurple
        button.tintColor = .white
        button.imageView?.setDimensions(height: 24, width: 24)
        button.addTarget(self, action: #selector(showNewMessages), for: .touchUpInside)
        return button
    }()
    
    var messages = [Message]()
    var messagesDictionary = [String: Message]()
    var timer: Timer?

    //Marks: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        authenticationUser()
    }
    
    
    //Marks:- Selector
    @objc func showProfile(){
       let controller = ProfileController()
        controller.delegate = self
       let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
       present(nav, animated: true, completion: nil)
        
    }
    
    @objc func showNewMessages(){
        let controller = NewMessageController()
        controller.delegate = self
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    @objc func handleReloadTable() {
        self.messages = Array(self.messagesDictionary.values)
        self.messages.sort(by: { (message1, message2) -> Bool in

            return message1.timeStamp?.int32Value > message2.timeStamp?.int32Value
        })
        DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
        })
    }

    //Marks:- API
    func authenticationUser() {
        if Auth.auth().currentUser?.uid == nil{
            presentLoginScreen()
            print("User is not logeed in . Present log in screen")
        }else{
            print("user id id \(Auth.auth().currentUser?.uid)")
        }
    }
    func observeUserMessages() {
        Service.currentMessage { (snapshot) in
            let messageId = snapshot.key
            self.fetchMessageWithMessageId(messageId)
        }
        
    }

    func fetchMessageWithMessageId(_ messageId: String) {
        Service.currentMessagewithId(messageId) { snapshot in
            if let dictionary = snapshot.value as? [String: AnyObject] {
               let message = Message(dictionary: dictionary)
                
               if let chatPartnerId = message.chatPartnerId() {
                 self.messagesDictionary[chatPartnerId] = message
                }
                self.attemptReloadOfTable()
            }
                
       }
        
    }
    
    //Marks: -Helper
    
    func presentLoginScreen(){
        DispatchQueue.main.async {
            let controller = LoginController()
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    func configureUI(){
        view.backgroundColor = .white
        configureNavigationBar(withTitle: "Messages", prefersLargeTitles: true)
        configureTableView()
        messages.removeAll()
        messagesDictionary.removeAll()
        tableView.reloadData()
        
        observeUserMessages()
        let image = UIImage(systemName: "person.circle.fill")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(showProfile))
        
        view.addSubview(messageButton)
        messageButton.setDimensions(height: 56, width: 56)
        messageButton.layer.cornerRadius = 56 / 2
        messageButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: 16, paddingRight: 24)
    }
    
    
    func configureTableView(){
        tableView.backgroundColor = .white
        tableView.rowHeight = 80
        tableView.register(ConversationCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        
        
        view.addSubview(tableView)
        tableView.frame = view.frame
   tableView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        
    }
    func attemptReloadOfTable() {
        self.timer?.invalidate()

        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
    }
   
}



extension ConvesationController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ConversationCell
        let message = messages[indexPath.row]
        cell.conversation = message
        if cell.messageTextLabel.text == nil {
            cell.messageTextLabel.text = "Media"
        }
        
        return cell
    }
   
    
    
}

//Marks:-UItableViewDelegate
extension ConvesationController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
            let message = messages[indexPath.row]
            
            guard let chatPartnerId = message.chatPartnerId() else {
                return
            }
            
            let ref = Database.database().reference().child("users").child(chatPartnerId)
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                guard let dictionary = snapshot.value as? [String: AnyObject] else {
                    return
                }
                
                let user = User(dictionary: dictionary)
                user.id = chatPartnerId
                self.showChatController(user)
                
                }, withCancel: nil)
        }
    
    func showChatController(_ user: User){
        let chatLogController = ChatController(user: user)
        navigationController?.pushViewController(chatLogController, animated: true)
    }
}


extension ConvesationController: NewMessageControllerDelegate {
    func controller(_ controller: NewMessageController, wantToChatWith user: User) {
        dismiss(animated: true, completion: nil)
        let chat = ChatController(user: user)
        navigationController?.pushViewController(chat, animated: true)
    }
    
    
}

extension ConvesationController: ProfileControllerDelegate {
    func handelSignOut() {
        do{
            try Auth.auth().signOut()
            presentLoginScreen()
            print("logout successFully")
        }catch {
            print("Error in signOut")
        }
    }
    
    
}
