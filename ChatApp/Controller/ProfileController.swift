
import UIKit
import Firebase

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
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Service.getUser(withUid: uid) { user in
            self.user = user
        }
    }
    //Mars:- Helpers
    
    func configureUI(){
        tableView.backgroundColor = .white
        
        tableView.tableHeaderView = headerView
        headerView.delegate = self
        headerView.imageDelegate = self
        tableView.register(ProfileCell.self, forCellReuseIdentifier: reuseIdentifer)
        tableView.tableFooterView = UIView()
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = 70
        tableView.backgroundColor = .systemGroupedBackground
        
        fotterView.delegate = self
        fotterView.frame = .init(x: 0, y: 0, width: view.frame.width, height: 100)
        tableView.tableFooterView = fotterView
       
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


extension ProfileController : ProfileDelegate, EditProfileImage, UIImagePickerControllerDelegate & UINavigationControllerDelegate  {
   
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
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let imageName = UUID().uuidString
        let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).png")
        
        if let uploadData = headerView.profileImageView.image?.pngData() {
            
            storageRef.putData(uploadData, metadata: nil, completion: { (_, error) in
                
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                storageRef.downloadURL(completion: { (url, err) in
                    if let err = err {
                        print(err.localizedDescription)
                        return
                    }
                    
                    guard let url = url else { return }
                    let values = ["profileImageUrl": url.absoluteString]
                    self.updteInDatabase(uid, values: values as [String : AnyObject])
                })
                
            })
        }
       
    }
    fileprivate func updteInDatabase(_ uid: String, values: [String: AnyObject]) {
        let ref = Database.database().reference()
        let usersReference = ref.child("users").child(uid)
        
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            
            if let err = err {
                print(err.localizedDescription)

                return
            }
           
        })
    }
    
}

extension ProfileController: ProfileFotterDelegate {
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
