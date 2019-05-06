//
//  UpcomingTableViewController.swift
//  TMDB_HW03.1
//
//  Created by Ryan Hua on 3/20/18.
//  Copyright © 2018 Ryan Hua. All rights reserved.
//

import UIKit
import Firebase
class UpcomingTableViewController: UITableViewController {

    var results: MovieResults?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        
        downloadJSON {
            print("JSON download successful")
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
            self.tableView.reloadData()
        }

        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.register(UpcomingMovieCell.self, forCellReuseIdentifier: "cellid")
    }
    
    func downloadJSON(completed: @escaping() -> () ) {
        let url = URL(string: MovieURLPrefix+"upcoming?api_key="+APIKey)
        URLSession.shared.dataTask(with: url!) {
            (data,response,error) in
            if error == nil {
                guard let jsondata = data else {return}
                do {
                    self.results = try JSONDecoder().decode(MovieResults.self, from: jsondata)
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
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implemetation, return the number of rows
        if let number = results?.movies.count{
            //print(number)
            return number
        }
        return 0
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        let cell = UpcomingMovieCell(style: .default, reuseIdentifier: "cellid")
        let ref = Database.database().reference()
        ref.child("movies").child(String((self.results?.movies[indexPath.row].id)!)).observeSingleEvent(of: .value, with: {(snapshot) in
            if snapshot.hasChild("users") {
                ref.child("movies").child(String((self.results?.movies[indexPath.row].id)!)).child("users").observeSingleEvent(of: .value, with: {(snapshot) in
                    cell.revNum.text = String(describing: snapshot.childrenCount)
                })
            }
            else {
                cell.revNum.text = "0"
            }
        })
        let uid = Auth.auth().currentUser?.uid
        let favref = ref.child("users").child(uid!)
        favref.observeSingleEvent(of: .value, with: {(snapshot) in
            if snapshot.hasChild("favorites") {
                favref.child("favorites").observeSingleEvent(of: .value, with: {(snapshot) in
                    if snapshot.hasChild(String((self.results?.movies[indexPath.row].id)!)) {
                        cell.favButton.backgroundColor = UIColor.orange
                    }
                })
            }
        })
        // Configure the cell...
        cell.link = self
        cell.movieTitle.text = results?.movies[indexPath.row].title
        let temp : String = (results?.movies[indexPath.row].poster_path)!
        cell.moviePoster.downloadedFrom(link: ImageURLPrefix+"w342"+temp)
        cell.favButton.tag = indexPath.row
        cell.favButton.addTarget(self, action: #selector(handlefav(sender:)), for: .touchUpInside)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let movie = results?.movies[indexPath.row] {
            self.showDetailOfMovie(movie:movie)
        }
    }
    func showDetailOfMovie(movie: MovieInfo) {
        let detailController = DetailTableViewController()
        detailController.view.backgroundColor = .white
        detailController.movie = movie.id
        detailController.downloadMovie {
            print("Movie Details download successful")
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
            self.tableView.reloadData()
            detailController.fetchUser()
            detailController.navigationItem.title = "Details"
            self.navigationController?.pushViewController(detailController, animated: true)
        }
    }
    @objc func handlefav(sender: UIButton) {
        guard let uid = Auth.auth().currentUser?.uid else{
            return
        }
        let ref = Database.database().reference()
        let currentCell = sender.superview?.superview as! UpcomingMovieCell
        let index = currentCell.favButton.tag
        if (sender.backgroundColor == UIColor.black) {
            sender.backgroundColor = UIColor.orange
            let userRef = ref.child("users").child(uid)
            let values = ["revnum":currentCell.revNum.text, "id": String(describing: (self.results?.movies[index].id)!), "poster_path" : self.results?.movies[index].poster_path, "title" : self.results?.movies[index].title] as [String : AnyObject]
            userRef.child("favorites").child(String(describing: (self.results?.movies[index].id)!)).updateChildValues(values, withCompletionBlock: {(err, ref) in
                if err != nil {
                    print (err ?? "")
                    return
                }
            })
        }
        else {
            sender.backgroundColor = UIColor.black
            let userref = ref.child("users").child(uid).child("favorites").child(String(describing: (self.results?.movies[index].id)!))
            userref.removeValue()
        }
    }    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            results?.movies.remove(at: indexPath.row)
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
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
    }
    
    override func didMove(toParentViewController parent: UIViewController?) {
        super.didMove(toParentViewController: parent)
        
        if parent != nil && self.navigationItem.titleView == nil {
            fetchUserAndSetupNavBarTitle()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        fetchUserAndSetupNavBarTitle()
    }
    /*
     override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
     
     } */
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
