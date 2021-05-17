
import UIKit
import Firebase

private let reuseIdentifier = "ConversationCell"

class ConvesationController:UIViewController{
   
    //Mark: - Properties
    private let tableView = UITableView()
    private let messageButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "message"), for: .normal)
        button.backgroundColor = .systemPurple
        button.tintColor = .white
        button.imageView?.setDimensions(height: 24, width: 24)
        button.addTarget(self, action: #selector(showNewMessages), for: .touchUpInside)
        return button
    }()
    
    //Marks: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        authenticationUser()
    }
    
    
    //Marks:- Selector
    @objc func showProfile(){
       logOut()
    }
    
    @objc func showNewMessages(){
        let controller = NewMessageController()
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
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
    
    func logOut(){
        do{
            try Auth.auth().signOut()
            presentLoginScreen()
            print("logout successFully")
        }catch {
            print("Error in signOut")
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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        
        
        view.addSubview(tableView)
        tableView.frame = view.frame
        
        
    }
    
    
   
}



extension ConvesationController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        cell.textLabel?.text = "Test Cell"
        return cell
    }
    
    
}


extension ConvesationController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}
