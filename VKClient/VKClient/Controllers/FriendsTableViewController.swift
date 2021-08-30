//
//  FriendsTableViewController.swift
//  VKClient
//
//  Created by Сергей Черных on 22.08.2021.
//

import UIKit

class FriendsTableViewController: UITableViewController {
    
    private let friends = Friends().list
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showFriendPhotos", sender: nil)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       guard let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath) as? FriendTableViewCell else { return UITableViewCell() }
        
        cell.configure(friend: friends[indexPath.row])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        72
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let photosVC = segue.destination as? PhotosCollectionViewController,
              let userID = tableView.indexPathForSelectedRow?[0] else { return }
        let photo = friends[userID].avatar
        photosVC.userPhotos.append(UserPhoto(photo: photo))
    }
}
