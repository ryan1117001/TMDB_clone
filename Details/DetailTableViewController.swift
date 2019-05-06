//
//  DetailTableViewController.swift
//  TMDB_HW03.1
//
//  Created by Ryan Hua on 4/11/18.
//  Copyright © 2018 Ryan Hua. All rights reserved.
//

import UIKit
import Firebase

class DetailTableViewController: UITableViewController {
    var rating : Double?
    var user : User?
    var responses : Responses?
    var reviews : Reviews?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    var details: MovieData!
    var movie : Int?
    func downloadMovie(completed: @escaping() -> () ) {
        let id = movie
        let url = URL(string: MovieURLPrefix+"\(id!)?api_key="+APIKey)
        URLSession.shared.dataTask(with: url!) {
            (data,response,error) in
            if error == nil {
                guard let jsondata = data else {return}
                do {
                    self.details = try JSONDecoder().decode(MovieData.self, from: jsondata)
                    DispatchQueue.main.async {
                        completed()
                    }
                }catch{
                    print("JSON Downloading Error!")
                }
            }
            } .resume()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 5
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.section == 0) {
            return 550
        }
        else {
            return 250
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configure the cell...
        
        if (indexPath.section == 0) {
            let cell = DetailTableViewCell(style: .default, reuseIdentifier: "cellid")
            cell.link = self
            cell.movieTitle.text = (details?.title)!
            cell.releaseDate.text = (details?.releaseDate)!
            var gtemp : String = "Genre: "
            for index in (details?.genres)! {
                gtemp += index.name! + ", "
            }
            cell.genres.text = gtemp
            cell.desc.text = (details?.overview)!
            cell.star1.image = getStar(starNumber: 1, forRating: (details.rating!/2))
            cell.star2.image = getStar(starNumber: 2, forRating: (details.rating!/2))
            cell.star3.image = getStar(starNumber: 3, forRating: (details.rating!/2))
            cell.star4.image = getStar(starNumber: 4, forRating: (details.rating!/2))
            cell.star5.image = getStar(starNumber: 5, forRating: (details.rating!/2))
            let ref = Database.database().reference().child("movies")
            ref.observeSingleEvent(of: .value, with: {(snapshot) in
                if snapshot.hasChild(String(describing: (self.details.id)!)) {
                    let more = ref.child(String(describing: (self.details.id)!))
                    more.observeSingleEvent(of: .value, with: {(snapshot) in
                        if let dictionary = snapshot.value as? [String : AnyObject] {
                            self.reviews = Reviews(dictionary : dictionary)
                            cell.dislike.text = self.reviews?.dislikes
                            cell.like.text = self.reviews?.likes
                        }
                    })
                }
                else {
                    let values = ["likes":"0", "dislikes":"0"] as [String : AnyObject]
                    ref.child(String(describing: (self.details.id)!)).updateChildValues(values, withCompletionBlock: {(err,ref) in
                        if err != nil {
                            print(err ?? "")
                            return
                        }
                        cell.dislike.text = "0"
                        cell.like.text = "0"
                    })
                }
            })
            cell.dislikeButton.addTarget(self, action: #selector(handlemoviedislike), for: .touchUpInside)
            cell.likeButton.addTarget(self, action: #selector(handlemovielike), for: .touchUpInside)
            return cell
        }
        else if (indexPath.section == 1) {
            let cell = UserReviewViewCell(style: .default, reuseIdentifier: "cellid")
            let ref = Database.database().reference().child("movies")
            let check = ref.child(String(describing: (self.details.id)!)).child("users")
            check.observeSingleEvent(of: .value, with: {(snapshot) in
                if snapshot.hasChild((self.user?.username)!) {
                    let ref = Database.database().reference()
                    let rev = ref.child("movies").child(String(describing: (self.details.id)!)).child("users").child((self.user?.username)!)
                    rev.observeSingleEvent(of: .value, with: {(snapshot) in
                        if let dictionary = snapshot.value as? [String : AnyObject] {
                            self.responses = Responses(dictionary: dictionary)
                            cell.link = self
                            cell.review.text = self.responses?.text
                            cell.dislike.text = self.responses?.dislike
                            cell.username.text = self.user?.username
                            cell.like.text = self.responses?.like
                        }
                    })
                }
                else {
                    let values = ["like": "0", "dislike" : "0", "username" : (self.user?.username)!, "text" : ""] as [String : AnyObject]
                    ref.child(String(describing: (self.details?.id)!)).child("users").child((self.user?.username)!).updateChildValues(values, withCompletionBlock: {(err,ref) in
                        if err != nil {
                            print(err ?? "")
                            return
                        }
                        self.responses = Responses(dictionary: values as [String : AnyObject])
                        cell.review.text = ""
                        cell.link = self
                        cell.dislike.text = "0"
                        cell.like.text = "0"
                        cell.username.text = self.user?.username
                    })
                }
            })
            
            cell.submitButton.addTarget(self, action: #selector(handlesubmit(sender:)), for: .touchUpInside)
            cell.dislikeButton.addTarget(self, action: #selector(handledislike), for: .touchUpInside)
            cell.likeButton.addTarget(self, action: #selector(handlelike), for: .touchUpInside)
            cell.deleteButton.addTarget(self, action: #selector(handledelete(sender:)), for: .touchUpInside)
            
            return cell
        }
        else {
            let cell = OtherReviewViewCell(style: .default, reuseIdentifier: "cellid")
            var count = 0
            let ref = Database.database().reference().child("movies").child(String(describing: (self.details.id)!)).child("users")
            ref.observeSingleEvent(of: .value, with: {(snapshot) in
                for rest in snapshot.children.allObjects as! [DataSnapshot] {
                    if ((count + 2) == indexPath.section && (self.user?.username == self.responses?.username)) {
                        guard let restDict = rest.value as? [String : AnyObject] else { continue }
                        let other = Responses(dictionary: restDict)
                        cell.dislike.text = other.dislike
                        cell.like.text = other.like
                        cell.review.text = other.text
                        cell.username.text = other.username
                        cell.dislikeButton.addTarget(self, action: #selector(self.handledislike), for: .touchUpInside)
                        cell.likeButton.addTarget(self, action: #selector(self.handlelike), for: .touchUpInside)
                    }
                    count += 1
                }
            })
            return cell
        }
    }
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else {
            //for some reason uid = nil
            return
        }
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: {(snapshot) in
            if let dictionary = snapshot.value as? [String : AnyObject] {
                self.user = User(dictionary: dictionary)
            }
        })
        
        tableView.reloadData()
    }
    func getStar(starNumber: Double, forRating rating: Double) -> UIImage {
        if rating >= starNumber {
            return #imageLiteral(resourceName: "fullstar")
        } else if rating + 0.5 >= starNumber {
            return #imageLiteral(resourceName: "halfstar")
        } else {
            return #imageLiteral(resourceName: "emptystar")
        }
    }
    
    @objc func handlelike() {
        let ref = Database.database().reference()
        let userRef = ref.child("movies").child(String(describing: (details?.id)!)).child("users").child((user?.username)!)
        var temp = Int((responses?.like)!)
        temp = temp! + 1
        let values = ["like" : String(describing: temp!)] as [String : Any]
        responses?.like = String(temp!)
        userRef.updateChildValues(values, withCompletionBlock: { (err, ref) in
            
            if err != nil {
                print(err ?? "")
                return
            }
        })
        tableView.reloadData()
    }
    @objc func handledislike() {
        let ref = Database.database().reference()
        let userRef = ref.child("movies").child(String(describing: (self.details.id)!)).child("users").child((user?.username)!)
        var temp = Int((responses?.dislike)!)
        temp = temp! + 1
        responses?.dislike = String(temp!)
        let values = ["dislike" : String(describing: temp!)] as [String : Any]
        userRef.updateChildValues(values, withCompletionBlock: { (err, ref) in
            
            if err != nil {
                print(err ?? "")
                return
            }
        })
        tableView.reloadData()
    }
    
    @objc func handlemovielike() {
        let ref = Database.database().reference()
        let userRef = ref.child("movies").child(String(describing: (details?.id)!))
        var temp = Int((reviews?.likes)!)
        temp = temp! + 1
        let values = ["likes" : String(describing: temp!)] as [String : Any]
        reviews?.likes = String(temp!)
        userRef.updateChildValues(values, withCompletionBlock: { (err, ref) in
            
            if err != nil {
                print(err ?? "")
                return
            }
        })
        tableView.reloadData()
    }
    @objc func handlemoviedislike() {
        let ref = Database.database().reference()
        let userRef = ref.child("movies").child(String(describing: (self.details.id)!))
        var temp = Int((reviews?.dislikes)!)
        temp = temp! + 1
        reviews?.dislikes = String(temp!)
        let values = ["dislikes" : String(describing: temp!)] as [String : Any]
        userRef.updateChildValues(values, withCompletionBlock: { (err, ref) in
            
            if err != nil {
                print(err ?? "")
                return
            }
        })
        tableView.reloadData()
    }
    @objc func handlesubmit(sender: UIButton) {
        guard let _ = Auth.auth().currentUser?.uid else{
            return
        }
        let currentCell = sender.superview as! UserReviewViewCell
        responses?.text = currentCell.review.text
        let ref = Database.database().reference()
        let userRef = ref.child("movies").child(String(describing: (self.details.id)!)).child("users").child((user?.username)!)
        let values = ["text" : currentCell.review.text!] as [String : Any]
        userRef.updateChildValues(values, withCompletionBlock: { (err, ref) in
            
            if err != nil {
                print(err ?? "")
                return
            }
        })
        tableView.reloadData()
    }
    @objc func handledelete(sender: UIButton) {
        guard let _ = Auth.auth().currentUser?.uid else{
            return
        }
        let ref = Database.database().reference()
        let userRef = ref.child("movies").child(String(describing: (self.details.id)!)).child("users").child((user?.username)!)
        userRef.removeValue()
        tableView.reloadData()
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
extension UIViewController
{
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}
