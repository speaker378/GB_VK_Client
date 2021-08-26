//
//  FindTableViewController.swift
//  VKClient
//
//  Created by Сергей Черных on 22.08.2021.
//

import UIKit

class FindTableViewController: CommunityTableViewController {

    override var communitys: [Community] { get { [
        Community(name: "Таверна Гарцующий пони", image: UIImage(named: "pony"), members: 509),
    ]}}

}
