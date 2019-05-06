//
//  LoginController.swift
//  TMDB_HW03.1
//
//  Created by Ryan Hua on 4/10/18.
//  Copyright © 2018 Ryan Hua. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController {

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        let stackview = UIStackView(arrangedSubviews: [emailTextField,passwordTextField,registerButton,loginButton])
        stackview.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackview)
        stackview.axis = .vertical
        stackview.distribution = .fillEqually
        stackview.spacing = 1.0
        stackview.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 300).isActive = true
        stackview.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 100).isActive = true
        stackview.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -100).isActive = true
        stackview.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
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
        
        button.addTarget(self, action: #selector(handleregister), for: .touchUpInside)
        
        return button
    }()
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .black
        button.setTitle("Login", for: UIControlState())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: UIControlState())
        
        button.addTarget(self, action: #selector(handlelogin), for: .touchUpInside)
        
        return button
    }()
    
    @objc func handlelogin() {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            print("Must put email and password")
            return
        }
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            
            if error != nil {
                print(error ?? "")
                return
            }

            let customtabbar = CustomTabBar()
            self.present(customtabbar, animated: true, completion: nil)
            
        })
    }
    @objc func handleregister() {
        let register = RegisterController()
        self.present(register, animated: true, completion: nil)
    }
}

