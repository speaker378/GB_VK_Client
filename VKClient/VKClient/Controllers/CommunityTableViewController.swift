//
//  CommunityTableViewController.swift
//  VKClient
//
//  Created by Сергей Черных on 22.08.2021.
//

import UIKit

class CommunityTableViewController: UITableViewController {
    
    var communitys: [Community] { get { [
        Community(name: "Мордор", image: UIImage(named: "mordor"), members: 30_946),
        Community(name: "Братство кольца", image: UIImage(named: "ring"), members: 9),
        Community(name: "Королевство Гондор", image: UIImage(named: "gondor"), members: 21_381),
    ]}}

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "CommunityCell", bundle: nil), forCellReuseIdentifier: "communityCell")
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return communitys.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "communityCell", for: indexPath) as? CommunityCell  else { return UITableViewCell() }
        
        cell.configure(community: communitys[indexPath.row]) 

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
