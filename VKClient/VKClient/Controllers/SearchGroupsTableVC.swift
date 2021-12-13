//
//  SearchGroupsTableVC.swift
//  VKClient
//
//  Created by Сергей Черных on 22.08.2021.
//

import UIKit
import Firebase

class SearchGroupsTableVC: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var groups = [Group]()
    var networkService = NetworkService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "GroupCell", bundle: nil), forCellReuseIdentifier: "groupCell")
    }
    
    private func fetchGroups(text: String) {
        networkService.getGroupsSearch(text: text) { [weak self] findedGroups in
            guard let self = self else { return }
            self.groups = findedGroups
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath) as? GroupCell  else { return UITableViewCell() }
        
        cell.configure(group: groups[indexPath.row])

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let joinAction = UIContextualAction(style: .destructive, title: "Вступить") { _, _, complete in
            let group = self.groups.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.networkService.groupMembershipAction(groupID: group.id, action: .join)
            complete(true)
        }
        
        joinAction.backgroundColor = .blue
        
        let configuration = UISwipeActionsConfiguration(actions: [joinAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        (64 + 4 * 2)
    }
}

extension SearchGroupsTableVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(SearchGroupsTableVC.reload), object: nil)
            self.perform(#selector(SearchGroupsTableVC.reload), with: nil, afterDelay: 1.25)
    }
    
    @objc func reload() {
        guard let searchText = searchBar.text else { return }
        guard searchText != "" else {
            groups.removeAll()
            tableView.reloadData()
            return
        }
        fetchGroups(text: searchText)
        saveFindedGroupsUserToFirebase(searchText)
    }
    
    func saveFindedGroupsUserToFirebase(_ text: String) {
        let storageRef = Database.database().reference(withPath: "users")
        let currentUser = storageRef.child(String(Session.shared.userId))
        let history = currentUser.child("searchHistory")
        history.child(getCurrentDateFormatterString()).setValue(text)
    }
    
    func getCurrentDateFormatterString() -> String {
        return Date().formatted(
            .dateTime
                .year()
                .month()
                .day()
                .hour()
                .minute()
                .second()
        )
    }
}
