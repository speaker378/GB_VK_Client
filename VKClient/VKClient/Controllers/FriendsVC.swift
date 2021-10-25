//
//  FriendsVC.swift
//  VKClient
//
//  Created by Сергей Черных on 22.08.2021.
//

import UIKit
import RealmSwift

class FriendsVC: UIViewController {
    
    @IBOutlet weak var friendsTableView: UITableView!
    
    private var friends: Results<RealmFriend>? { didSet{
        self.setupFriendsData()
        self.friendsTableView.reloadData() } }
    private var friendsFirstLetters = [String]()
    private var friendsDict = [String: [RealmFriend]]()
    private var loader: Loader?
    var networkService = NetworkService()

    override func viewDidLoad() {
        super.viewDidLoad()
        friends = try? RealmService.load(typeOf: RealmFriend.self)
        fetchFriends()
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
    
    private func fetchFriends() {
        networkService.getFriends { [weak self] in
            self?.friends = try? RealmService.load(typeOf: RealmFriend.self)
        }
    }
    
    private func setupFriendsData() {
        guard let friends = friends else { return }
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
        headerView.textLabel?.font = UIFont.boldSystemFont(ofSize: 14)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        CGFloat(0.01)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        30
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let mycell = cell as? FriendTableViewCell else { return }
        mycell.animate(UITapGestureRecognizer())
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

