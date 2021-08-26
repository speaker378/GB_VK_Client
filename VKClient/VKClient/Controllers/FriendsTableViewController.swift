//
//  FriendsTableViewController.swift
//  VKClient
//
//  Created by Сергей Черных on 22.08.2021.
//

import UIKit

class FriendsTableViewController: UITableViewController {
    
    private let friends = [
        Friend(name: "Aragorn", avatar: UIImage(named: "Aragorn")),
        Friend(name: "Boromir", avatar: UIImage(named: "Boromir")),
        Friend(name: "Frodo", avatar: UIImage(named: "Frodo")),
        Friend(name: "Galadriel", avatar: UIImage(named: "Galadriel")),
        Friend(name: "Gandalf", avatar: UIImage(named: "Gandalf")),
        Friend(name: "Legolas", avatar: UIImage(named: "Legolas")),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showFriendPhotos", sender: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return friends.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let headerView = UIView()
            headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 5
        }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath)
        cell.textLabel?.text = friends[indexPath.section].name
        cell.imageView?.image = friends[indexPath.section].avatar
        cell.textLabel?.textColor = UIColor.black
        cell.textLabel?.font = UIFont.systemFont(ofSize: 22)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let photosVC = segue.destination as? PhotosCollectionViewController else { return }
        guard let userID = tableView.indexPathForSelectedRow?[0] else { return }
        let photo = friends[userID].avatar
        photosVC.userPhotos.append(UserPhoto(photo: photo))
    }
}
