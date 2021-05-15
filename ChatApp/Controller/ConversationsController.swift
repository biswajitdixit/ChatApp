
import UIKit

private let reuseIdentifier = "ConversationCell"

class ConvesationController:UIViewController{
   
    //Mark: - Properties
    private let tableView = UITableView()
    
    //Marks: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureTableView()
    }
    
    
    //Marks:- Selector
    @objc func showProfile(){
        print(123)
    }
    
    //Marks: -Helper
    
    func configureUI(){
        view.backgroundColor = .white
        configureNavigationBar()
        let image = UIImage(systemName: "person.circle.fill")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(showProfile))
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
    
    
    func configureNavigationBar(){
        let apperance = UINavigationBarAppearance()
        apperance.configureWithOpaqueBackground()
        apperance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        apperance.backgroundColor = .systemPurple
        
        navigationController?.navigationBar.standardAppearance = apperance
        navigationController?.navigationBar.compactAppearance = apperance
        navigationController?.navigationBar.scrollEdgeAppearance = apperance
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Messages"
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isTranslucent = true
        
        
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
