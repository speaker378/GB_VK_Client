//
//  NewsTableVC.swift
//  VKClient
//
//  Created by Сергей Черных on 08.09.2021.
//

import UIKit
import Nuke

class NewsTableVC: UITableViewController {
    
    private var myNews = [NewsPublication]()
    var networkService = NetworkService()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "NewsCell", bundle: nil), forCellReuseIdentifier: "newsCell")
        tableView.register(NewsHeader.self, forHeaderFooterViewReuseIdentifier: "NewsHeader")
        tableView.register(NewsFooter.self, forHeaderFooterViewReuseIdentifier: "NewsFooter")
        tableView.sectionHeaderTopPadding = 10
        fetchNews()
    }
    
    func fetchNews() {
        networkService.getNewsFeed { [weak self] myNews in
            guard let self = self else { return }
            self.myNews = myNews
            self.tableView.reloadData()
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        myNews.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var cellsInSection = 0
        let sectionData = myNews[section]
        if sectionData.attachments != nil { cellsInSection += 1 }
        if sectionData.text != "" { cellsInSection += 1 }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as? NewsCell else { return UITableViewCell() }

        cell.configure(news: myNews[indexPath.row])

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: header
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "NewsHeader") as? NewsHeader else { return UITableViewHeaderFooterView() }
        let options = ImageLoadingOptions(
          placeholder: UIImage(systemName: "photo"),
          transition: .fadeIn(duration: 0.25)
        )
        if let url = URL(string: myNews[section].avatarURL ?? "") {
            Nuke.loadImage(with: url, options: options, into: view.creatorAvatar)
        }
        view.creatorName.text = myNews[section].creatorName
        view.dateLabel.text = Date(timeIntervalSince1970: TimeInterval(myNews[section].date)).timeAgoDisplay()
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        54
    }

    //MARK: footer
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "NewsFooter") as? NewsFooter else { return UITableViewHeaderFooterView() }
        view.likesLabel.text = String(myNews[section].likes.count)
        view.commentsLabel.text = String(myNews[section].comments.count)
        view.repostsLabel.text = String(myNews[section].reposts.count)
        view.viewsLabel.text = String(myNews[section].views.count)
        return view
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        30
    }
    
}
