//
//  MyCommunitysTableVC.swift
//  VKClient
//
//  Created by Сергей Черных on 22.08.2021.
//

import UIKit
import RealmSwift

class MyCommunitysTableVC: UITableViewController {
    private var myCommunitys: Results<RealmCommunity>?
    private var communitysToken: NotificationToken?
    var networkService = NetworkService()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "CommunityCell", bundle: nil), forCellReuseIdentifier: "communityCell")
        myCommunitys = try? RealmService.load(typeOf: RealmCommunity.self)
        fetchCommunitys()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        communitysObserveSetup()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        communitysToken?.invalidate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchCommunitys()
    }
    
    private func fetchCommunitys() {
        networkService.getCommunitys(userId: Session.shared.userId) { }
    }
    
    private func communitysObserveSetup() {
        communitysToken = myCommunitys?.observe { [weak self] changes in
            switch changes {
            case .initial:
                self?.tableView.reloadData()
            case .update:
                self?.tableView.reloadData()
            case .error(let error):
                print(error)
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myCommunitys?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "communityCell", for: indexPath) as? CommunityCell, let myCommunitys = myCommunitys else { return UITableViewCell() }
        
        cell.configure(community: myCommunitys[indexPath.row])

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
        
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let leaveAction = UIContextualAction(style: .destructive, title: "Покинуть") { _, _, complete in
            if let group = self.myCommunitys?[indexPath.row] {
                self.networkService.leaveCommunitys(groupID: group.id)
                try? RealmService.delete(object: group)
            }
            complete(true)
        }

        leaveAction.backgroundColor = .red

        let configuration = UISwipeActionsConfiguration(actions: [leaveAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
}
