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
    var startTime = Int(Date().timeIntervalSince1970)
    var nextFrom: String!
    var isLoading = false

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(NewsTextCell.self, forCellReuseIdentifier: "NewsTextCell")
        tableView.register(NewsPhotoCell.self, forCellReuseIdentifier: "NewsPhotoCell")
        tableView.register(NewsHeader.self, forHeaderFooterViewReuseIdentifier: "NewsHeader")
        tableView.register(NewsFooter.self, forHeaderFooterViewReuseIdentifier: "NewsFooter")
        tableView.sectionHeaderTopPadding = 10
        tableView.separatorStyle = .none
        tableView.backgroundColor = .tertiarySystemGroupedBackground
        setupPullToRefresh()
        tableView.prefetchDataSource = self
        fetchNews()
    }
    
    private func setupPullToRefresh() {
        tableView.refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Загрузка...")
        refreshControl?.addTarget(self, action: #selector(refreshNews), for: .valueChanged)
    }
    
    @objc private func refreshNews() {
        self.refreshControl?.beginRefreshing()
        networkService.getNewsFeed(startTime: self.startTime, completion: { [weak self] news, nextFrom in
            guard let self = self,
                  news.count > 0
            else { self?.refreshControl?.endRefreshing()
                return }
            
            self.myNews = news + self.myNews
            self.startTime = news.first!.date + 1
            self.nextFrom = nextFrom
            let indexSet = IndexSet(integersIn: 0..<news.count)
            self.refreshControl?.endRefreshing()
            self.tableView.insertSections(indexSet, with: .automatic)
        })
    }
    
    func fetchNews() {
        networkService.getNewsFeed { [weak self] myNews, nextFrom in
            guard let self = self else { return }
            self.myNews = myNews
            self.nextFrom = nextFrom
            self.startTime = myNews.first!.date + 1
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
        return cellsInSection
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionData = myNews[indexPath.section]
        
        switch indexPath.row {
        case 0:
            if sectionData.text != "" {
                guard let textCell = tableView.dequeueReusableCell(withIdentifier: "NewsTextCell", for: indexPath) as? NewsTextCell else { return UITableViewCell() }
                textCell.newsText.text = sectionData.text
                return textCell
            }
            fallthrough
            
        case 1:
            guard let photoSizes = sectionData.attachments?.first?.photo?.sizes else { return UITableViewCell() }
            guard let photoCell = tableView.dequeueReusableCell(withIdentifier: "NewsPhotoCell", for: indexPath) as? NewsPhotoCell else { return UITableViewCell() }
            photoCell.configure(photoSizes)
            return photoCell
            
        default:
            return UITableViewCell()
        }
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

extension NewsTableVC: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let maxSection = indexPaths.map ({ $0.section }).max() else { return }
        
        if maxSection > myNews.count - 3, !isLoading {
            isLoading = true
            networkService.getNewsFeed(startFrom: nextFrom) { [weak self] news, nextFrom in
                guard let self = self else { return }
                let indexSet = IndexSet(integersIn: self.myNews.count ..< self.myNews.count + news.count)
                self.myNews.append(contentsOf: news)
                self.nextFrom = nextFrom
                self.tableView.insertSections(indexSet, with: .automatic)
                self.isLoading = false
            }
        }
    }
}
