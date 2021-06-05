import UIKit
class ProfileLogout:UIView {
    
    //Marks:- Properties
    private lazy var logoutButton:UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Logout", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = .systemPurple
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(Logout), for: .touchUpInside)
        return button
    }()
    
    //Marks:- LifeCycle
    
    override init(frame: CGRect){
        super.init(frame: frame)
        addSubview(logoutButton)
        logoutButton.anchor(left: leftAnchor, right: rightAnchor, paddingLeft: 32, paddingRight: 32)
        logoutButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        logoutButton.centerY(inView: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Selectors:- Selectors
    @objc func Logout(){
        NotificationCenter.default.post(name:Notification.Name("logOut"), object: nil)
    }
    
}
