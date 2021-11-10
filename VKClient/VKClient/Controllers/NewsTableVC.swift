//
//  NewsTableVC.swift
//  VKClient
//
//  Created by Сергей Черных on 08.09.2021.
//

import UIKit

class NewsTableVC: UITableViewController {
    
    private var myNews = [NewsPublication]()
    var networkService = NetworkService()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "NewsCell", bundle: nil), forCellReuseIdentifier: "newsCell")
        fetchNews()
    }
    
    func fetchNews() {
        networkService.getNewsFeed { [weak self] myNews in
            guard let self = self else { return }
            self.myNews = myNews
            self.tableView.reloadData()
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myNews.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as? NewsCell else { return UITableViewCell() }

        cell.configure(news: myNews[indexPath.row])

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
