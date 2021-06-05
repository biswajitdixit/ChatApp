
import UIKit

private let reuseIdentifer = "ProfileCell"

protocol ProfileControllerDelegate: class {
    func handelSignOut()
}
class ProfileController: UITableViewController {
    
    //Marks:- Properties
    private var user: User? {
        didSet { headerView.user = user}
    }
    
    private lazy var headerView = Profile(frame: .init(x: 0, y: 0, width: view.frame.width, height: 380))
    
    private let fotterView = ProfileLogout()
    
    weak var delegate: ProfileControllerDelegate?
    
    //Mrks:- LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchUser()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    //Marks:-Selectors
    
    
    //Marks:- API
    func fetchUser(){
        let uid = Service.currentUser()
        Service.getUser(withUid: uid) { user in
            self.user = user
        }
    }
    //Mars:- Helpers
    
    func configureUI(){
        tableView.backgroundColor = .white
        
        tableView.tableHeaderView = headerView
        headerView.delegate = self
        tableView.register(ProfileCell.self, forCellReuseIdentifier: reuseIdentifer)
        tableView.tableFooterView = UIView()
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = 70
        tableView.backgroundColor = .systemGroupedBackground
        
        fotterView.frame = .init(x: 0, y: 0, width: view.frame.width, height: 100)
        tableView.tableFooterView = fotterView
        NotificationCenter.default.addObserver(self, selector: #selector(notificationRecived), name: Notification.Name("logOut"), object: nil)
        
    }
    
    //Mars:-Selector
    @objc func notificationRecived(){
        handelLogout()
    }
}

extension ProfileController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  ProfileViewModel.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifer, for: indexPath) as! ProfileCell
        
        let viewModel = ProfileViewModel(rawValue: indexPath.row)
        cell.viewModel = viewModel
        return cell
    }
}


extension ProfileController : ProfileDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate  {
    
    func dismissController() {
        dismiss(animated: true, completion: nil)
    }
    func editProfileImage() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        headerView.profileImageView.image = image
        updateImage()
        dismiss(animated: true, completion: nil)
        
        
    }
    
    func updateImage(){
        let uid = Service.currentUser()
        Service.uploadImage(profileImage: headerView.profileImageView.image!, completion: { (url, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let url = url else { return }
            let values = ["profileImageUrl": url.absoluteString]
            Service.updteInDatabase(uid, values: values as [String : AnyObject])
            
        })
    }
    
}

extension ProfileController{
    
    func handelLogout() {
        let alert = UIAlertController(title: nil, message: "Are you sure you want to logout?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { _ in
            self.dismiss(animated: true) {
                self.delegate?.handelSignOut()
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel ", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
}

extension ProfileController{
    func editUsername() {
        var txtField = UITextField()
        
        let alert = UIAlertController(title: "Edit UserName", message: "", preferredStyle: .alert)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "User Name"
            alertTextField.text = self.headerView.userNamelabel.text
            txtField = alertTextField
        }
        let action = UIAlertAction(title: "Edit", style: .default) { (action) in
            self.updateUserName(userName:txtField.text!)
            self.headerView.userNamelabel.text = txtField.text
            print("Edited")
        }
        let action1 = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alert.addAction(action)
        alert.addAction(action1)
        present(alert, animated: true, completion: nil)
    }
    
    func updateUserName(userName:String){
        let uid = Service.currentUser()
        let values = ["userName": userName]
        Service.updteInDatabase(uid, values: values as [String : AnyObject])
    }
    
}
