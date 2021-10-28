//
//  AllCommunitysTableVC.swift
//  VKClient
//
//  Created by Сергей Черных on 22.08.2021.
//

import UIKit
import Firebase

class AllCommunitysTableVC: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var allCommunitys = [Community]()
    var networkService = NetworkService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "CommunityCell", bundle: nil), forCellReuseIdentifier: "communityCell")
    }
    
    private func fetchCommunitys(text: String) {
        networkService.getCommunitysSearch(text: text) { [weak self] allCommunitys in
            guard let self = self else { return }
            self.allCommunitys = allCommunitys
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allCommunitys.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "communityCell", for: indexPath) as? CommunityCell  else { return UITableViewCell() }
        
        cell.configure(community: allCommunitys[indexPath.row])

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let joinAction = UIContextualAction(style: .destructive, title: "Вступить") { _, _, complete in
            let group = self.allCommunitys.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.networkService.joinCommunitys(groupID: group.id)
            complete(true)
        }
        
        joinAction.backgroundColor = .blue
        
        let configuration = UISwipeActionsConfiguration(actions: [joinAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
}

extension AllCommunitysTableVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(AllCommunitysTableVC.reload), object: nil)
            self.perform(#selector(AllCommunitysTableVC.reload), with: nil, afterDelay: 1.25)
    }
    
    @objc func reload() {
        guard let searchText = searchBar.text else { return }
        guard searchText != "" else {
            allCommunitys.removeAll()
            tableView.reloadData()
            return
        }
        fetchCommunitys(text: searchText)
        saveFindedCommunitysUserToFirebase(searchText)
    }
    
    func saveFindedCommunitysUserToFirebase(_ text: String) {
        let storageRef = Database.database().reference(withPath: "users")
        let currentUser = storageRef.child(String(Session.shared.userId))
        let history = currentUser.child("searchHistory")
        history.child(getCurrentDateFormaterString()).setValue(text)
    }
    
    func getCurrentDateFormaterString() -> String {
        let now = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: now)
        let year = components.year ?? 0
        let month = components.month ?? 0
        let day = components.day ?? 0
        let hour = components.hour ?? 0
        let minute = components.minute ?? 0
        let second = components.second ?? 0
        let dataString = "\(year):\(month):\(day) - \(hour):\(minute):\(second)"
        return dataString
    }
}
