//
//  RegisterController.swift
//  TMDB_HW03.1
//
//  Created by Ryan Hua on 4/10/18.
//  Copyright © 2018 Ryan Hua. All rights reserved.
//

import UIKit
import Firebase

class RegisterController: UIViewController {
    let profileurl: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Profile Url"
        tf.text = "https://firebasestorage.googleapis.com/v0/b/tmdb-82180.appspot.com/o/no-photo.png?alt=media&token=e72ed2bd-2f51-49bd-8601-393c02c62fd3"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    let usernameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Username"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    let fullnameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Full Name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    let hometownTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Hometown"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    let occupationTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Occupation"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isSecureTextEntry = true
        return tf
    }()
    let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .black
        button.setTitle("Register", for: UIControlState())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: UIControlState())
        
        button.addTarget(self, action: #selector(profileCreate), for: .touchUpInside)
        
        return button
    }()
    let exitButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .black
        button.setTitle("Exit", for: UIControlState())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: UIControlState())
        
        button.addTarget(self, action: #selector(exit), for: .touchUpInside)
        
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        let stackview = UIStackView(arrangedSubviews: [emailTextField,usernameTextField,passwordTextField,fullnameTextField,hometownTextField,occupationTextField,registerButton,exitButton])
        view.addSubview(stackview)
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.axis = .vertical
        stackview.distribution = .fillEqually
        stackview.spacing = 3.0
        stackview.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 200).isActive = true
        stackview.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 75).isActive = true
        stackview.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -75).isActive = true
        stackview.heightAnchor.constraint(equalToConstant: 300).isActive = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func exit() {
        let lc = LoginController()
        self.present(lc, animated: true, completion: nil)
    }
    @objc func profileCreate() {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            print("Must enter username")
            return
        }
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            
            if error != nil {
                print(error ?? "")
                return
            }
            
            guard (user?.uid) != nil else {
                return
            }
            guard let uid = Auth.auth().currentUser?.uid else{
                return
            }
            let ref = Database.database().reference()
            let usersReference = ref.child("users").child(uid)
            
            let values = ["email": self.emailTextField.text, "fullname" : self.fullnameTextField.text, "username" : self.usernameTextField.text, "hometown" : self.hometownTextField.text, "occupation" : self.occupationTextField.text, "profileurl" : self.profileurl.text] as [String : AnyObject]
            
            usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                if err != nil {
                    print(err ?? "")
                    return
                }
            })
            
            let customtabbar = CustomTabBar()
            customtabbar.selectedIndex = 0
            self.present(customtabbar, animated: true, completion: nil)
        })
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
