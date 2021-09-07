//
//  FindTableViewController.swift
//  VKClient
//
//  Created by Сергей Черных on 22.08.2021.
//

import UIKit

class AllCommunitysTableViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var visibleCommunitys = [Community]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "CommunityCell", bundle: nil), forCellReuseIdentifier: "communityCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        visibleCommunitys = allCommunitysList
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visibleCommunitys.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "communityCell", for: indexPath) as? CommunityCell  else { return UITableViewCell() }
        
        cell.configure(community: visibleCommunitys[indexPath.row])

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let joinAction = UIContextualAction(style: .destructive, title: "Вступить") { _, _, complete in
            var removeItem = self.visibleCommunitys.remove(at: indexPath.row)
            allCommunitysList.remove(at: allCommunitysList.firstIndex(of: removeItem)!)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            removeItem.members += 1
            myCommunitysList.append(removeItem)
            complete(true)
        }
        
        joinAction.backgroundColor = .blue
        
        let configuration = UISwipeActionsConfiguration(actions: [joinAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
}

extension AllCommunitysTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterCommunitys(with: searchText)
    }
    
    private func filterCommunitys(with text: String) {
        guard !text.isEmpty else {
            visibleCommunitys = allCommunitysList
            tableView.reloadData()
            return }
        visibleCommunitys = allCommunitysList.filter { $0.name.lowercased().contains(text.lowercased()) }
        tableView.reloadData()
    }
}
