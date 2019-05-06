//
//  FavoriteController.swift
//  TMDB_HW03.1
//
//  Created by Ryan Hua on 4/21/18.
//  Copyright © 2018 Ryan Hua. All rights reserved.
//

import UIKit
import Firebase

class FavoriteController: UITableViewController {
    var count : Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCount()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return count!
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
    func fetchUserAndSetupNavBarTitle() {
        guard let uid = Auth.auth().currentUser?.uid else {
            //for some reason uid = nil
            return
        }
        
        // fetch User info! Set up Navigation Bar!
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                //                self.navigationItem.title = dictionary["name"] as? String
                
                let user = User(dictionary: dictionary)
                self.setupNavBarWithUser(user)
            }
            
        }, withCancel: nil)
    }
    
    // When NavBar TitleView is Tapped!!! Edit User Profile!!!
    @objc private func handleTap(){
        //print("Tapped")
        
        let profileController = ProfileController()
        
        profileController.fetchProfile()
        
        navigationController?.pushViewController(profileController, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    func fetchCount() {
        guard let uid = Auth.auth().currentUser?.uid else{
            return
        }
        let ref = Database.database().reference().child("users").child(uid)
        ref.observeSingleEvent(of: .value, with: {(snapshot) in
            if snapshot.hasChild("favorites") {
                ref.child("favorites").observeSingleEvent(of: .value, with: {(snapshot) in
                    self.count = Int(snapshot.childrenCount)
                    self.tableView.reloadData()
                })
            }
            else {
                self.count = 0
            }
        })
    }
    func setupNavBarWithUser(_ user: User) {
        
        let titleView = TitleView(frame: CGRect(x: 0, y: 0, width: 150, height: 40))
        
        self.navigationItem.titleView = titleView
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        
        titleView.isUserInteractionEnabled = true
        
        titleView.addGestureRecognizer(tap)
        
        if let profileImageUrl = user.profileurl {
            titleView.profileImageView.downloadImageUsingCacheWithLink(profileImageUrl)
        }
        titleView.nameLabel.text = user.username
        tableView.reloadData()
    }
    
    override func didMove(toParentViewController parent: UIViewController?) {
        super.didMove(toParentViewController: parent)
        
        if parent != nil && self.navigationItem.titleView == nil {
            fetchUserAndSetupNavBarTitle()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        fetchUserAndSetupNavBarTitle()
        fetchCount()
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = FavoriteCell(style: .default, reuseIdentifier: "cellid")
        let uid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child("users").child(uid!)
        var count = 0
        ref.observeSingleEvent(of: .value, with: {(snapshot) in
            if snapshot.hasChild("favorites") {
                ref.child("favorites").observeSingleEvent(of: .value, with: {(snapshot) in
                    for rest in snapshot.children.allObjects as! [DataSnapshot] {
                        if (count == indexPath.row) {
                            guard let restDict = rest.value as? [String : AnyObject] else {continue}
                            let other = FavMovie(dictionary: restDict)
                            cell.id.text = other.id
                            cell.posterpath.text = other.poster_path
                            cell.movieTitle.text = other.title
                            cell.moviePoster.downloadedFrom(link: ImageURLPrefix+"w342"+other.poster_path!)
                            cell.revNum.text = other.revnum
                            cell.favButton.backgroundColor = .orange
                            cell.favButton.tag = indexPath.row
                            cell.favButton.addTarget(self, action: #selector(self.handlefav(sender:)), for: .touchUpInside)
                            return
                       }
                       count += 1
                    }
                })
            }
        })

        // Configure the cell...

        return cell
    }
    @objc func handlefav(sender: UIButton) {
        guard let uid = Auth.auth().currentUser?.uid else{
            return
        }
        let ref = Database.database().reference()
        let currentCell = sender.superview?.superview as! FavoriteCell
        if (sender.backgroundColor == UIColor.black) {
            sender.backgroundColor = UIColor.orange
            let userRef = ref.child("users").child(uid)
            let values = ["revnum": currentCell.revNum.text, "id": currentCell.id.text, "poster_path" : currentCell.posterpath.text, "title" : currentCell.movieTitle.text] as [String : AnyObject]
            userRef.child("favorites").child(currentCell.id.text!).updateChildValues(values, withCompletionBlock: {(err, ref) in
                if err != nil {
                    print (err ?? "")
                    return
                }
            })
        }
        else {
            sender.backgroundColor = UIColor.black
            let userref = ref.child("users").child(uid).child("favorites").child(currentCell.id.text!)
            userref.removeValue()
            count! -= 1
            tableView.reloadData()
        }
    }
    //goes to another cell when pressed
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailController = DetailTableViewController()
        detailController.view.backgroundColor = .white
        let cell = tableView.cellForRow(at: indexPath) as! FavoriteCell
        detailController.movie = Int(cell.id.text!)
        detailController.downloadMovie {
            print("Movie Details download successful")
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
            self.tableView.reloadData()
            detailController.fetchUser()
            detailController.navigationItem.title = "Details"
            self.navigationController?.pushViewController(detailController, animated: true)
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
