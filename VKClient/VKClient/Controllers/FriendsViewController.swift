//
//  FriendsTableViewController.swift
//  VKClient
//
//  Created by Сергей Черных on 22.08.2021.
//

import UIKit

class FriendsViewController: UIViewController {
    
    @IBOutlet weak var friendsTableView: UITableView!
    
    private var myFriends = friendsList
    private var friendsFirstLetters: [String] = []
    private var friendsDict = [String: [Friend]]()
    
    private let stackView: UIStackView = {
            $0.distribution = .fill
            $0.axis = .horizontal
            $0.alignment = .center
            $0.spacing = 8
            return $0
        }(UIStackView())

        private let circle1 = UIView()
        private let circle2 = UIView()
        private let circle3 = UIView()
        private lazy var circles = [circle1, circle2, circle3]

    func animate(action: @escaping ()-> Void) {
            self.view.isUserInteractionEnabled = false
            let jumpDuration: Double = 0.33
            let delayDuration: Double = 0
            let totalDuration = delayDuration + jumpDuration * 2

            let jumpRelativeDuration = jumpDuration / totalDuration
            let jumpRelativeTime = delayDuration / totalDuration
            let fallRelativeTime = (delayDuration + jumpDuration) / totalDuration

            for (index, circle) in circles.enumerated() {
                circle.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
                let delay = jumpDuration*2 * TimeInterval(index) / TimeInterval(circles.count)
                UIView.animateKeyframes(withDuration: totalDuration, delay: delay, options: [.autoreverse], animations: {
                    UIView.addKeyframe(withRelativeStartTime: jumpRelativeTime, relativeDuration: jumpRelativeDuration) {
                        circle.frame.origin.y -= 20
                    }
                    UIView.addKeyframe(withRelativeStartTime: fallRelativeTime, relativeDuration: jumpRelativeDuration) {
                        circle.frame.origin.y += 20
                    }
                },
                completion: {_ in
                    if index == self.circles.count - 1 {
                        self.circles.forEach{ $0.backgroundColor = .none }
                        self.view.isUserInteractionEnabled = true
                        action()
                    }
                } )
            }
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFriendsData()
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        circles.forEach {
            $0.layer.cornerRadius = 20/2
            $0.layer.masksToBounds = true
            $0.backgroundColor = .none
            stackView.addArrangedSubview($0)
            $0.widthAnchor.constraint(equalToConstant: 20).isActive = true
            $0.heightAnchor.constraint(equalTo: $0.widthAnchor).isActive = true
        }
    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let photosVC = segue.destination as? PhotosCollectionViewController else { return }
        guard let indexPath = friendsTableView.indexPathForSelectedRow else { return }
        let friends = friendsDict[friendsFirstLetters[indexPath.section]]
        guard let friend = friends?[indexPath.row] else { return }
        let photo = friend.avatar
        photosVC.userPhotos.append(UserPhoto(photo: photo))
    }
    
    private func setupFriendsData() {
        for friend in myFriends {
            let firstChar = String(friend.name.first!).capitalized
            if friendsDict[firstChar] == nil {
                friendsDict[firstChar] = [friend]
                friendsFirstLetters.append(firstChar)
            } else {
                friendsDict[firstChar]!.append(friend)
            }
        }
    }
}


extension FriendsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        animate(action: { self.performSegue(withIdentifier: "showFriendPhotos", sender: indexPath) })
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        88
    }
    
}


extension FriendsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return friendsFirstLetters.count
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return friendsFirstLetters
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return friendsFirstLetters[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor(red: 0.1, green: 0.1, blue: 0.5, alpha: 0.3)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = friendsFirstLetters[section]
        return friendsDict[key]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath) as? FriendTableViewCell else { return UITableViewCell() }
        
        let key = friendsFirstLetters[indexPath.section]
        let friendsForKey = friendsDict[key]
        guard let friend = friendsForKey?[indexPath.row] else { return cell }
        
        cell.configure(friend: friend)
        return cell
    }
}

