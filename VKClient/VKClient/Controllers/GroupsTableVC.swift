//
//  GroupsTableVC.swift
//  VKClient
//
//  Created by Сергей Черных on 22.08.2021.
//

import UIKit
import RealmSwift

class GroupsTableVC: UITableViewController {
    private var groups: Results<RealmGroup>?
    private var groupsToken: NotificationToken?
    var networkService: NetworkServiceProxy = NetworkServiceProxy(networkService: NetworkService())
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "GroupCell", bundle: nil), forCellReuseIdentifier: "groupCell")
        groups = try? RealmService.load(typeOf: RealmGroup.self)
        fetchGroups()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        groupsObserveSetup()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        groupsToken?.invalidate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchGroups()
    }
    
    private func fetchGroups() {
        let operationQ = OperationQueue()
        operationQ.maxConcurrentOperationCount = 5
        
        let fetchOperation = FetchDataGroupsOperation()
        let parseOperation = ParseDataGroupsOperation()
        let saveToRealmOperation = SaveGroupsToRealmOperation()
        
        parseOperation.addDependency(fetchOperation)
        saveToRealmOperation.addDependency(parseOperation)
        
        operationQ.addOperation(fetchOperation)
        operationQ.addOperation(parseOperation)
        operationQ.addOperation(saveToRealmOperation)
    }
    
    private func groupsObserveSetup() {
        groupsToken = groups?.observe { [weak self] changes in
            switch changes {
            case .initial:
                self?.tableView.reloadData()
            case let .update(_, deletions, insertions, modifications):
                self?.tableView.beginUpdates()
                self?.tableView.deleteRows(at: deletions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                self?.tableView.insertRows(at: insertions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                self?.tableView.reloadRows(at: modifications.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                self?.tableView.endUpdates()
            case .error(let error):
                print(error)
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath) as? GroupCell, let myGroups = groups else { return UITableViewCell() }
        
        cell.configure(group: myGroups[indexPath.row])

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
        
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let leaveAction = UIContextualAction(style: .destructive, title: "Покинуть") { _, _, complete in
            if let group = self.groups?[indexPath.row] {
                self.networkService.groupMembershipAction(groupID: group.id, action: .leave)
                try? RealmService.delete(object: group)
            }
            complete(true)
        }

        leaveAction.backgroundColor = .red

        let configuration = UISwipeActionsConfiguration(actions: [leaveAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        (64 + 4 * 2)
    }
}
