import UIKit

class RegistrationController:UIViewController{
    
    //Mark:- Properties
    private var viewModel = RegistrationViewModel()
    private var profileImage: UIImage?
    
    private let plusPhotoButton: UIButton = {
        let buttton = UIButton(type: .system)
        buttton.setImage(#imageLiteral(resourceName: "plus_photo"), for: .normal)
        buttton.tintColor = .systemPurple
        buttton.addTarget(self, action: #selector(handelSelectPhoto), for: .touchUpInside)
        buttton.imageView?.contentMode = .scaleAspectFill
        buttton.clipsToBounds = true
        return buttton
    }()
    
    private lazy var emailContainerView: UIView = {
        return InputContainerView(image: UIImage(systemName: "envelope")!, textField: emailTextField)
    }()
    
    private lazy var passwordContainerView: InputContainerView = {
        return InputContainerView(image: UIImage(systemName: "lock")!, textField: passwordTextField)
        
    }()
    
    private lazy var userNameContainerView: UIView = {
        return InputContainerView(image: UIImage(systemName: "person")!, textField: userNameTextField)
    }()
    
    private lazy var fullNameContainerView: UIView = {
        return InputContainerView(image: UIImage(systemName: "person")!, textField: fullNameTextField)
    }()
    
    private let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.layer.cornerRadius = 20
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = #colorLiteral(red: 1, green: 0.5212053061, blue: 1, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.setHeight(height: 50)
        button.isEnabled = false
        button.addTarget(self, action: #selector(handelSignUp), for: .touchUpInside)
        return button
    }()
    
    private let emailTextField = CustomTextField(placeholder: "Email")
    private let userNameTextField = CustomTextField(placeholder: "User Name")
    private let fullNameTextField = CustomTextField(placeholder: "Full Name")
    
    private let passwordTextField: CustomTextField = {
        let txtFld = CustomTextField(placeholder: "Password")
        txtFld.isSecureTextEntry = true
        return txtFld
    }()
    
    private let alreadyHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributeTitle = NSMutableAttributedString(string: "Already have an account?  ",
                                                       attributes: [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.systemPurple])
        
        attributeTitle.append(NSAttributedString(string: "Log In", attributes: [.font: UIFont.boldSystemFont(ofSize: 16), .foregroundColor: UIColor.systemPurple
                                                                                
        ]))
        
        button.setAttributedTitle(attributeTitle, for: .normal)
        button.addTarget(self, action: #selector(handelShowLogin), for: .touchUpInside)
        return button
    }()
    //Mark:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configurationNotificationManager()
    }
    
    //Mark:- Selector
    @objc func handelSelectPhoto(){
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
        
    }
    
    @objc func handelShowLogin(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handelSignUp(){
        
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        guard let fullName = fullNameTextField.text else {return}
        guard let userName = userNameTextField.text?.lowercased() else {return}
        guard let profileImage = profileImage else {return}
        showLoader(true,withText: "Signing You Up")
        Service.registerUser(email: email, password: password) { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let uid = user?.user.uid else {
                return
            }
            Service.uploadImage( profileImage: profileImage, completion: {url,error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                guard let url = url else { return }
                let values = ["fullName": fullName, "email": email,"userName": userName, "profileImageUrl": url.absoluteString]
                Service.updteInDatabase(uid, values: values as [String : AnyObject])
                self.showLoader(false)
                self.dismiss(animated: true, completion: nil)
                
            })
        }
    }
    
    @objc func textDidChange(sender: UITextField){
        if sender == emailTextField {
            viewModel.email = sender.text
        }else if sender == passwordTextField{
            viewModel.password = sender.text
        }else if sender == fullNameTextField{
            viewModel.fullName = sender.text
        }else{
            viewModel.userName = sender.text
        }
        checkFormStatus()
    }
    
    @objc func keyboardWillShow(){
        if view.frame.origin.y == 0{
            self.view.frame.origin.y -= 88
        }
    }
    
    @objc func keyboardWillHide(){
        if view.frame.origin.y != 0{
            view.frame.origin.y = 0
        }
    }
    
    //Mark: - Helper
    
    
    func configureUI(){
        view.backgroundColor = .white
        view.addSubview(plusPhotoButton)
        plusPhotoButton.centerX(inView: view)
        plusPhotoButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 15)
        plusPhotoButton.setDimensions(height: 200, width: 200)
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView, fullNameContainerView, userNameContainerView, passwordContainerView, signUpButton])
        stack.axis = .vertical
        stack.spacing = 16
        
        view.addSubview(stack)
        stack.anchor(top:plusPhotoButton.bottomAnchor, left: view.leftAnchor,right: view.rightAnchor, paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.anchor(left:view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 32, paddingBottom: 16,  paddingRight: 32)
        
    }
    
    func configurationNotificationManager(){
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        fullNameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        userNameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

//Marks:- UIImagePickerControllDlegate

extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        profileImage = image
        plusPhotoButton.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        plusPhotoButton.layer.borderColor = UIColor.white.cgColor
        plusPhotoButton.layer.borderWidth = 3.0
        plusPhotoButton.layer.cornerRadius = 200/2
        dismiss(animated: true, completion: nil)
        
    }
}

extension RegistrationController: AuthenticationControllerProtocol {
    func checkFormStatus() {
        if viewModel.formIsValid{
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = .systemPurple
        }else{
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = #colorLiteral(red: 1, green: 0.5212053061, blue: 1, alpha: 1)
        }
    }
    
}
