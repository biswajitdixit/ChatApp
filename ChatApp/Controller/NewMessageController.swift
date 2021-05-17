import UIKit

private let reuseIdentifier = "UserCell"

class NewMessageController: UITableViewController {
    //Mark:- Properties
    
    //Mark:- LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    //Selector:-
    @objc func handelDismiss(){
        dismiss(animated: true, completion: nil)
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
        return 2
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) 
      //  cell.textLabel?.text = "Test Cell"
        return cell
    }
    
}
