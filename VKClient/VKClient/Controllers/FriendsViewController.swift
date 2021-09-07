//
//  FriendsTableViewController.swift
//  VKClient
//
//  Created by Сергей Черных on 22.08.2021.
//

import UIKit

class FriendsViewController: UIViewController {
    
    @IBOutlet weak var friendsTableView: UITableView!
    
    private var myFriends = friendsList
    private var friendsFirstLetters: [String] = []
    private var friendsDict = [String: [Friend]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFriendsData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let photosVC = segue.destination as? PhotosCollectionViewController else { return }
        guard let indexPath = friendsTableView.indexPathForSelectedRow else { return }
        let friends = friendsDict[friendsFirstLetters[indexPath.section]]
        guard let friend = friends?[indexPath.row] else { return }
        let photo = friend.avatar
        photosVC.userPhotos.append(UserPhoto(photo: photo))
    }
    
    private func setupFriendsData() {
        for friend in myFriends {
            let firstChar = String(friend.name.first!).capitalized
            if friendsDict[firstChar] == nil {
                friendsDict[firstChar] = [friend]
                friendsFirstLetters.append(firstChar)
            } else {
                friendsDict[firstChar]!.append(friend)
            }
        }
    }
}


extension FriendsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showFriendPhotos", sender: nil)
        friendsTableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        88
    }
    
}


extension FriendsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return friendsFirstLetters.count
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return friendsFirstLetters
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return friendsFirstLetters[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor(red: 0.1, green: 0.1, blue: 0.5, alpha: 0.3)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = friendsFirstLetters[section]
        return friendsDict[key]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath) as? FriendTableViewCell else { return UITableViewCell() }
        
        let key = friendsFirstLetters[indexPath.section]
        let friendsForKey = friendsDict[key]
        guard let friend = friendsForKey?[indexPath.row] else { return cell }
        
        cell.configure(friend: friend)
        return cell
    }
}

