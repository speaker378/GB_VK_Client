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
    private let session = URLSession.shared
    private var taskSearchCommunitys: URLSessionDataTask? = nil
    
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
    
    
    func getCommunitys(userId: Int, complition: @escaping () -> Void) {
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
        let path = "/method/groups.search"
        let params = [
            "q" : text,
            "count" : "50",
        ]
        let url = url(from: path, params: params)
        let request = URLRequest(url: url)
        
        if taskSearchCommunitys != nil { taskSearchCommunitys!.cancel() }
        
        taskSearchCommunitys = session.dataTask(with: request) { responseData, urlResponse, error in
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
        taskSearchCommunitys!.resume()
    }
    
    func communityMembershipAction(groupID: Int, action: communityMembershipAction) {
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
    enum communityMembershipAction: String {
        case join
        case leave
    }
}
