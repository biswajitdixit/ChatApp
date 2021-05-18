import UIKit

private let reuseIdentifier = "UserCell"

protocol NewMessageControllerDelegate: class {
    func controller(_ controller: NewMessageController, wantToChatWith user: User)
}

class NewMessageController: UITableViewController {
    //Mark:- Properties
    
    private var users = [User]()
    weak var delegate: NewMessageControllerDelegate?
    
    //Mark:- LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchUsers()
    }
    
    //Selector:-
    
    @objc func handelDismiss(){
        dismiss(animated: true, completion: nil)
    }
    
    //Marks:- Api
    
    func fetchUsers(){
        Service.fetchUser { users in
            self.users = users
            self.tableView.reloadData()
            
            print("in new message \(users)")
        }
    }
    //Marks:- Helpers
    
    func configureUI(){
        configureNavigationBar(withTitle: "New Message", prefersLargeTitles: false)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handelDismiss))
        
        tableView.tableFooterView = UIView()
        tableView.register(UserCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 80
        
        
    }
}

//Marks:-UITableViewDataSource

extension NewMessageController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return users.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UserCell
        cell.user = users[indexPath.row]
        return cell
    }
    
}

//Marks:- UiTableViewDelegate

extension NewMessageController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.controller(self, wantToChatWith: users[indexPath.row])
        
    }
}


