//
//  ProfileController.swift
//  
//
//  Created by Ryan Hua on 4/10/18.
//

import UIKit
import Firebase

class ProfileController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var profileurl: String?
    var temp : NowPlayingTableViewController?
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
    let updateButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .black
        button.setTitle("Update", for: UIControlState())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: UIControlState())
        
        button.addTarget(self, action: #selector(handleUpdate), for: .touchUpInside)
        
        return button
    }()
    let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .black
        button.setTitle("Logout", for: UIControlState())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: UIControlState())
        
        button.addTarget(self, action: #selector(logout), for: .touchUpInside)
        
        return button
    }()
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "profile")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        
        // Tapping Action!!!
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    @objc func handleSelectProfileImageView() {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        // show Image Picker!!!! (Modally)
        present(picker, animated: true, completion: nil)
    }
    
    // UIImagePickerController Delegates!!!
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            profileImageView.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    @objc func handleUpdate() {
        
        guard let _ = Auth.auth().currentUser?.uid else{
            return
        }
        //successfully authenticated user
        
        // upload profile image
        let imageName = UUID().uuidString
        let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).jpg")
        
        // Compress Image into JPEG type
        if let profileImage = self.profileImageView.image, let uploadData = UIImageJPEGRepresentation(profileImage, 0.1) {
            
            _ = storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                guard let metadata = metadata else {
                    // Uh-oh, an error occurred!
                    print("Error when uploading profile image")
                    return
                }
                // Metadata contains file metadata such as size, content-type, and download URL.
                self.profileurl = metadata.downloadURL()?.absoluteString
                self.update()
            }
        }
    }
    func setupProfileImageView() {
        //need x, y, width, height constraints
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled picker")
        dismiss(animated: true, completion: nil)
    }
    func update() {
        guard let uid = Auth.auth().currentUser?.uid else{
            return
        }
        let ref = Database.database().reference()
        let userRef = ref.child("users").child(uid)
        let values = ["fullname" : self.fullnameTextField.text, "username" : self.usernameTextField.text, "hometown" : self.hometownTextField.text, "occupation" : self.occupationTextField.text, "profileurl" : self.profileurl] as [String : AnyObject]
        userRef.updateChildValues(values, withCompletionBlock: { (err, ref) in
            
            if err != nil {
                print(err ?? "")
                return
            }
        })
    }
    @objc func logout() {
        // Sign-out!!!
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        let lc = LoginController()
        self.present(lc, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Edit Profile"
        view.addSubview(profileImageView)
        setupProfileImageView()
        fetchProfile()
        view.backgroundColor = .white
        let stackview = UIStackView(arrangedSubviews: [usernameTextField,fullnameTextField,hometownTextField,occupationTextField,updateButton,logoutButton])
        view.addSubview(stackview)
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.axis = .vertical
        stackview.distribution = .fillEqually
        stackview.spacing = 0.4
        stackview.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 300).isActive = true
        stackview.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 25).isActive = true
        stackview.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -25).isActive = true
        stackview.heightAnchor.constraint(equalToConstant: 100).isActive = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func fetchProfile() {
        guard let uid = Auth.auth().currentUser?.uid else {
            //for some reason uid = nil
            return
        }
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: {(snapshot) in
            if let dictionary = snapshot.value as? [String : AnyObject] {
                let user = User(dictionary: dictionary)
                self.setupProfileWithUser(user)
            }
        })
    }
    func setupProfileWithUser(_ user: User) {
        if let url = user.profileurl {
            profileImageView.downloadImageUsingCacheWithLink(url)
        }
        if let username = user.username {
            usernameTextField.text = username
        }
        if let fullname = user.fullname {
            fullnameTextField.text = fullname
        }
        if let hometown = user.hometown {
            hometownTextField.text = hometown
        }
        if let occupation = user.occupation {
            occupationTextField.text = occupation
        }
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
