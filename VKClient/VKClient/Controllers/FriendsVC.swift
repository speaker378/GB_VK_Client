//
//  FriendsVC.swift
//  VKClient
//
//  Created by Сергей Черных on 22.08.2021.
//

import UIKit
import RealmSwift
import PromiseKit

class FriendsVC: UIViewController {
    
    @IBOutlet weak var friendsTableView: UITableView!
    
    private var friends: [ProfileForAdapter] = []
    private var friendsFirstLetters = [String]()
    private var friendsDict = [String : [ProfileForAdapter]]()
    private var loader: Loader?
    private var friendsToken: NotificationToken?
    var networkService = ProfileAdapter()

    override func viewDidLoad() {
        super.viewDidLoad()
        networkService.getProfiles { [weak self] friends in
            self?.friends = friends
            self?.setupFriendsData()
        }
        loader = Loader(rootView: view)
    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let photosVC = segue.destination as? PhotosCollectionVC else { return }
        guard let indexPath = friendsTableView.indexPathForSelectedRow else { return }
        let friends = friendsDict[friendsFirstLetters[indexPath.section]]
        guard let friend = friends?[indexPath.row] else { return }
        let userID = friend.userID
        photosVC.userID = userID
    }
    
    private func setupFriendsData() {
        for friend in friends where friend.friendStatus == 3 {
            let firstChar = String(friend.firstName.first!).capitalized
            if friendsDict[firstChar] == nil {
                friendsDict[firstChar] = [friend]
                friendsFirstLetters.append(firstChar)
            } else {
                if !friendsDict[firstChar]!.contains(friend) {
                    friendsDict[firstChar]!.append(friend)
                }
            }
        }
        friendsFirstLetters = friendsFirstLetters.sorted()
        friendsTableView.reloadData()
    }
}


extension FriendsVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            loader!.animate(action: { self.performSegue(withIdentifier: "showFriendPhotos", sender: indexPath) })
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        88
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let headerView = view as? UITableViewHeaderFooterView else { return }
        headerView.textLabel?.font = UIFont.system(size: 14)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        30
    }
}


extension FriendsVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return friendsFirstLetters.count
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return friendsFirstLetters
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return friendsFirstLetters[section]
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

