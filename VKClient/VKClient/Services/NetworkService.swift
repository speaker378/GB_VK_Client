//
//  NetworkService.swift
//  VKClient
//
//  Created by Сергей Черных on 01.10.2021.
//

import UIKit
import RealmSwift

final class NetworkService {
    private let clientId = "7998302"
    private let versionAPI = "5.131"
    private let session = URLSession.shared
    private var taskSearchGroups: URLSessionDataTask? = nil
    
    private func url(from path: String, params: [String: String]) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.vk.com"
        components.path = path
        components.queryItems = params.map { URLQueryItem(name: $0, value: $1) }
        components.queryItems! += [
            URLQueryItem(name: "access_token", value: Session.shared.token),
            URLQueryItem(name: "v", value: versionAPI),
        ]
        return components.url!
    }
    
    func getAuthorizeRequest() -> URLRequest {
        var urlConstructor = URLComponents()
        urlConstructor.scheme = "https"
        urlConstructor.host = "oauth.vk.com"
        urlConstructor.path = "/authorize"
        urlConstructor.queryItems = [
            URLQueryItem(name: "client_id", value: clientId),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "scope", value: "336918"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: versionAPI),
        ]
        let request = URLRequest(url: urlConstructor.url!)
        return request
    }
    
    func getNewsFeed(completion: @escaping ([NewsPublication]) -> Void) {
        let path = "/method/newsfeed.get"
        let params = [
            "filters" : "post",
            "count" : "20"
        ]
        let url = url(from: path, params: params)
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) { responseData, urlResponse, error in
            guard let response = urlResponse as? HTTPURLResponse,
                  (200...299).contains(response.statusCode),
                  error == nil,
                  let data = responseData
            else { return completion([]) }
            
            let dispatchGroup = DispatchGroup()
            var news = [NewsPublication]()
            var profiles: [Profile]?
            var groups: [Group]?
            
            do {
                dispatchGroup.enter()
                news = try JSONDecoder().decode(VKResponse<NewsPublication>.self, from: data).response.items
                profiles = try JSONDecoder().decode(VKResponse<NewsPublication>.self, from: data).response.profiles
                groups = try JSONDecoder().decode(VKResponse<NewsPublication>.self, from: data).response.groups
                dispatchGroup.leave()
            } catch  {
                dispatchGroup.leave()
                print(error)
            }
            
            
            for i in 0..<news.count {
                DispatchQueue.global().async(group: dispatchGroup) {
                    if news[i].sourceID < 0 {
                        let group = groups?.first(where: { $0.id == -news[i].sourceID })
                        news[i].avatarURL = group?.avatarUrlString
                        news[i].creatorName = group?.name
                    } else {
                        let profile = profiles?.first(where: { $0.userID == news[i].sourceID })
                        news[i].avatarURL = profile?.avatarUrlString
                        news[i].creatorName = profile?.firstName
                    }
                }
            }
            
            dispatchGroup.notify(queue: .main) {
                completion(news)
            }
        }
        task.resume()
    }
    
    func getFriends(complition: @escaping () -> Void) {
        let path = "/method/friends.get"
        let params = ["fields" : "photo_100,online,friend_status"]
        let url = url(from: path, params: params)
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) { responseData, urlResponse, error in
            guard let response = urlResponse as? HTTPURLResponse,
                  (200...299).contains(response.statusCode),
                  error == nil,
                  let data = responseData
            else { return complition() }
            
            do {
                let friends = try JSONDecoder().decode(VKResponse<Profile>.self, from: data).response.items
                let realmFriends = friends.map { RealmProfile(friend: $0) }
                DispatchQueue.main.async {
                    try? RealmService.save(items: realmFriends)
                    complition()
                }
            } catch  {
                print(error)
            }
        }
        task.resume()
    }
    
    func getAllPhotos(userId: Int, complition: @escaping () -> Void) {
        let path = "/method/photos.getAll"
        let params = [
            "owner_id" : String(userId),
            "extended" : "1",
            "count" : "200",
        ]
        let url = url(from: path, params: params)
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) { responseData, urlResponse, error in
            guard let response = urlResponse as? HTTPURLResponse,
                  (200...299).contains(response.statusCode),
                  error == nil,
                  let data = responseData
            else { return complition() }
            
            do {
                let jsonPhotos = try JSONDecoder().decode(VKResponse<Photo>.self, from: data).response.items
                let realmPhotos = jsonPhotos.map { RealmUserPhoto(userPhoto: $0) }
                DispatchQueue.main.async {
                    try? RealmService.save(items: realmPhotos)
                    let photos = List<RealmUserPhoto>()
                    photos.append(objectsIn: realmPhotos)
                    let friend = try? RealmService.load(typeOf: RealmProfile.self).filter("userID == \(userId)")
                    let realm = try? Realm()
                    try? realm?.write{
                        friend?.first?.userPhotos = photos
                    }
                    
                    complition()
                }
            } catch  {
                print(error)
            }
        }
        task.resume()
    }
    
    func likePhoto(ownerID: Int, itemID: Int, action: likeAction) {
        let path = "/method/likes.\(action.rawValue)"
        let params = [
            "type" : "photo",
            "owner_id" : "\(ownerID)",
            "item_id" : "\(itemID)",
        ]
        let url = url(from: path, params: params)
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request)
        task.resume()
    }
    
    
    func getGroups(userId: Int, complition: @escaping () -> Void) {
        let path = "/method/groups.get"
        let params = [
            "user_id" : String(userId),
            "extended" : "1",
        ]
        let url = url(from: path, params: params)
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) { responseData, urlResponse, error in
            guard let response = urlResponse as? HTTPURLResponse,
                  (200...299).contains(response.statusCode),
                  error == nil,
                  let data = responseData
            else { return complition() }
            
            do {
                let groups = try JSONDecoder().decode(VKResponse<Group>.self, from: data).response.items
                let realmGroups = groups.map { RealmGroup(group: $0) }
                DispatchQueue.main.async {
                    try? RealmService.save(items: realmGroups)
                    complition()
                }
            } catch  {
                print(error)
            }
        }
        task.resume()
    }
    
    func getGroupsSearch(text: String, complition: @escaping ([Group]) -> Void) {
        let path = "/method/groups.search"
        let params = [
            "q" : text,
            "count" : "50",
        ]
        let url = url(from: path, params: params)
        let request = URLRequest(url: url)
        
        if taskSearchGroups != nil { taskSearchGroups!.cancel() }
        
        taskSearchGroups = session.dataTask(with: request) { responseData, urlResponse, error in
            guard let response = urlResponse as? HTTPURLResponse,
                  (200...299).contains(response.statusCode),
                  error == nil,
                  let data = responseData
            else { return complition([]) }
            
            do {
                let groups = try JSONDecoder().decode(VKResponse<Group>.self, from: data).response.items
                DispatchQueue.main.async {
                    complition(groups)
                }
            } catch  {
                print(error)
            }
        }
        taskSearchGroups!.resume()
    }
    
    func groupMembershipAction(groupID: Int, action: groupMembershipAction) {
        let path = "/method/groups.\(action.rawValue)"
        let params = [
            "group_id" : String(groupID),
        ]
        let url = url(from: path, params: params)
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request)
        task.resume()
    }
    
}

extension NetworkService {
    enum likeAction: String {
        case add
        case delete
    }
    enum groupMembershipAction: String {
        case join
        case leave
    }
}
