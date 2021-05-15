import UIKit

class LoginController:UIViewController{
    
    //Mark:- Properties
    
    private let iconImage: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(systemName: "bubble.right")
        imgView.tintColor = .white
        return imgView
    }()
    
    private lazy var emailContainerView: UIView = {
        return InputContainerView(image: #imageLiteral(resourceName: "ic_mail_outline_white_2x"), textField: emailTextField)
    }()
    
    private lazy var passwordContainerView: InputContainerView = {
         return InputContainerView(image: #imageLiteral(resourceName: "ic_lock_outline_white_2x"), textField: passwordTextField)

     
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.setHeight(height: 50)
        return button
    }()
    
    private let emailTextField = CustomTextField(placeholder: "Email")
       
    
    private let passwordTextField: CustomTextField = {
        let txtFld = CustomTextField(placeholder: "Password")
        txtFld.isSecureTextEntry = true
        return txtFld
    }()
    
    private let dontHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributeTitle = NSMutableAttributedString(string: "Don't have an account?  ",
                                                       attributes: [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.white])
        
        attributeTitle.append(NSAttributedString(string: "Sign Up", attributes: [.font: UIFont.boldSystemFont(ofSize: 16), .foregroundColor: UIColor.white
                                                                                               
        ]))
        
        button.setAttributedTitle(attributeTitle, for: .normal)
        return button
    }()
    
    //Mark:- Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //Mark: - Helper
    
    func configureUI(){
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        
        configureGradiantLayer()
        
        view.addSubview(iconImage)
        iconImage.centerX(inView: view)
        iconImage.anchor(top:view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        iconImage.setDimensions(height: 120, width: 120)
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView, passwordContainerView, loginButton])
        stack.axis = .vertical
        stack.spacing = 16
        
        view.addSubview(stack)
        stack.anchor(top:iconImage.bottomAnchor, left: view.leftAnchor,right: view.rightAnchor, paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.anchor(left:view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 32, paddingBottom: 16,  paddingRight: 32)
    }
    
    
    func configureGradiantLayer() {
        let gradiant = CAGradientLayer()
        gradiant.colors = [UIColor.systemPurple.cgColor, UIColor.systemPink.cgColor]
        gradiant.locations = [0, 1]
        view.layer.addSublayer(gradiant)
        gradiant.frame = view.frame
    }
}
