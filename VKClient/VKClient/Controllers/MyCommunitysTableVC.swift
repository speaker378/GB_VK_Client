//
//  MyCommunitysTableVC.swift
//  VKClient
//
//  Created by Сергей Черных on 22.08.2021.
//

import UIKit

class MyCommunitysTableVC: UITableViewController {
    private var myCommunitys = [Community]()
    var networkService = NetworkService()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "CommunityCell", bundle: nil), forCellReuseIdentifier: "communityCell")
        fetchCommunitys()
    }
    
    private func fetchCommunitys() {
        networkService.getCommunitys(userId: 677589579) { [weak self] myCommunitys in
            guard let self = self else { return }
            self.myCommunitys = myCommunitys
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchCommunitys()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myCommunitys.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "communityCell", for: indexPath) as? CommunityCell  else { return UITableViewCell() }
        
        cell.configure(community: myCommunitys[indexPath.row])

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
        
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let leaveAction = UIContextualAction(style: .destructive, title: "Покинуть") { _, _, complete in
            let group = self.myCommunitys.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.networkService.leaveCommunitys(groupID: group.id)
            complete(true)
        }
        
        leaveAction.backgroundColor = .red
        
        let configuration = UISwipeActionsConfiguration(actions: [leaveAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
}
