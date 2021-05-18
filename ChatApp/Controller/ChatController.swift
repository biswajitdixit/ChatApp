import UIKit

class ChatController: UICollectionViewController {
    
    //Marks:- Properties
    
    private let user:User
    
    private lazy var customInputView :CustomInputView = {
        let iv = CustomInputView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
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
        
        print("user is \(user.userName)")
    }
    
    override var inputAccessoryView: UIView? {
        get{ return customInputView }
    }
    
    override var canBecomeFirstResponder: Bool{
        return true
    }
    
       
    
    //Mark:- Helpers
    
    func configureUI(){
        collectionView.backgroundColor = .white
        configureNavigationBar(withTitle: user.userName, prefersLargeTitles: false)
    
    }
    
}
