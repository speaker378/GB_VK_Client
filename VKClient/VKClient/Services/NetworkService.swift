//
//  NetworkService.swift
//  VKClient
//
//  Created by Сергей Черных on 01.10.2021.
//

import UIKit
import RealmSwift

final class NetworkService {
        
    private let clientId = "7963810"
    private let versionAPI = "5.131"
    private var requiredParameters: [URLQueryItem]
    private let session = URLSession.shared
    private var urlConstructor = URLComponents()
    private var task: URLSessionDataTask? = nil

    init() {
        urlConstructor.scheme = "https"
        urlConstructor.host = "api.vk.com"
        requiredParameters = [URLQueryItem(name: "access_token", value: Session.shared.token),
                              URLQueryItem(name: "v", value: versionAPI)]
    }
    
    func getAuthorizeRequest() -> URLRequest {
        var urlConstructor = urlConstructor
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
    
    func getFriends(complition: @escaping () -> Void) {
        var constructor = urlConstructor
        constructor.path = "/method/friends.get"
        constructor.queryItems = requiredParameters + [
            URLQueryItem(name: "fields", value: "photo_100,online,friend_status"),
        ]
        guard let url = constructor.url else { return complition() }
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) { responseData, urlResponse, error in
            guard let response = urlResponse as? HTTPURLResponse,
                  (200...299).contains(response.statusCode),
                  error == nil,
                  let data = responseData
            else { return complition() }
            
            do {
                let friends = try JSONDecoder().decode(VKResponse<Friend>.self, from: data).response.items
                let realmFriends = friends.map { RealmFriend(friend: $0) }
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
        var constructor = urlConstructor
        constructor.path = "/method/photos.getAll"
        constructor.queryItems = requiredParameters + [
            URLQueryItem(name: "owner_id", value: String(userId)),
            URLQueryItem(name: "extended", value: "1"),
            URLQueryItem(name: "count", value: "200"),
        ]
        guard let url = constructor.url else { return complition() }
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) { responseData, urlResponse, error in
            guard let response = urlResponse as? HTTPURLResponse,
                  (200...299).contains(response.statusCode),
                  error == nil,
                  let data = responseData
            else { return complition() }
            
            do {
                let jsonPhotos = try JSONDecoder().decode(VKResponse<UserPhoto>.self, from: data).response.items
                let realmPhotos = jsonPhotos.map { RealmUserPhoto(userPhoto: $0) }
                DispatchQueue.main.async {
                    try? RealmService.save(items: realmPhotos)
                    let photos = List<RealmUserPhoto>()
                    photos.append(objectsIn: realmPhotos)
                    let friend = try? RealmService.load(typeOf: RealmFriend.self).filter("userID == \(userId)")
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
        var constructor = urlConstructor
        constructor.path = "/method/likes.\(action.rawValue)"
        constructor.queryItems = requiredParameters + [
            URLQueryItem(name: "type", value: "photo"),
            URLQueryItem(name: "owner_id", value: "\(ownerID)"),
            URLQueryItem(name: "item_id", value: "\(itemID)"),
        ]
        guard let url = constructor.url else { return }
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request)
        task.resume()
    }
    
    
    func getCommunitys(userId: Int, complition: @escaping () -> Void) {
        var constructor = urlConstructor
        constructor.path = "/method/groups.get"
        constructor.queryItems = requiredParameters + [
            URLQueryItem(name: "user_id", value: String(userId)),
            URLQueryItem(name: "extended", value: "1"),
        ]
        guard let url = constructor.url else { return complition() }
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) { responseData, urlResponse, error in
            guard let response = urlResponse as? HTTPURLResponse,
                  (200...299).contains(response.statusCode),
                  error == nil,
                  let data = responseData
            else { return complition() }
            
            do {
                let communitys = try JSONDecoder().decode(VKResponse<Community>.self, from: data).response.items
                let realmCommunitys = communitys.map { RealmCommunity(community: $0) }
                DispatchQueue.main.async {
                    try? RealmService.save(items: realmCommunitys)
                    complition()
                }
            } catch  {
                print(error)
            }
        }
        task.resume()
    }
    
    func getCommunitysSearch(text: String, complition: @escaping ([Community]) -> Void) {
        var constructor = urlConstructor
        constructor.path = "/method/groups.search"
        constructor.queryItems = requiredParameters + [
            URLQueryItem(name: "q", value: text),
            URLQueryItem(name: "count", value: "50"),
        ]
        guard let url = constructor.url else { return complition([]) }
        let request = URLRequest(url: url)
        if task != nil { task!.cancel() }
        
        task = session.dataTask(with: request) { responseData, urlResponse, error in
            guard let response = urlResponse as? HTTPURLResponse,
                  (200...299).contains(response.statusCode),
                  error == nil,
                  let data = responseData
            else { return complition([]) }
            
            do {
                let communitys = try JSONDecoder().decode(VKResponse<Community>.self, from: data).response.items
                DispatchQueue.main.async {
                    complition(communitys)
                }
            } catch  {
                print(error)
            }
        }
        task!.resume()
    }
    
    func joinCommunitys(groupID: Int) {
        var constructor = urlConstructor
        constructor.path = "/method/groups.join"
        constructor.queryItems = requiredParameters + [
            URLQueryItem(name: "group_id", value: String(groupID)),
        ]
        guard let url = constructor.url else { return }
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request)
        task.resume()
    }
    
    func leaveCommunitys(groupID: Int) {
        var constructor = urlConstructor
        constructor.path = "/method/groups.leave"
        constructor.queryItems = requiredParameters + [
            URLQueryItem(name: "group_id", value: String(groupID)),
        ]
        guard let url = constructor.url else { return }
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
}
