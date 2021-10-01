//
//  NetworkService.swift
//  VKClient
//
//  Created by Сергей Черных on 01.10.2021.
//

import UIKit

final class NetworkService {
        
    private let clientId = "7963810"
    private let versionAPI = "5.131"
    private var requiredParameters: [URLQueryItem]
    private let session = URLSession.shared
    private var urlConstructor = URLComponents()

    init() {
        urlConstructor.scheme = "https"
        urlConstructor.host = "api.vk.com"
        requiredParameters = [URLQueryItem(name: "access_token", value: Session.shared.token),
                              URLQueryItem(name: "v", value: versionAPI)]
    }
    
    private func getData(_ request: URLRequest) {
        session.dataTask(with: request) { responseData, urlResponse, error in
            guard let response = urlResponse as? HTTPURLResponse,
                  (200...299).contains(response.statusCode),
                  error == nil,
                  let data = responseData
            else { return }
            let json = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
            DispatchQueue.main.async {
                print(json!)}
        }.resume()
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
    
    func getFriends() {
        var constructor = urlConstructor
        constructor.path = "/method/friends.get"
        constructor.queryItems = requiredParameters + [
            URLQueryItem(name: "fields", value: "photo_100,online"),
        ]
        let request = URLRequest(url: constructor.url!)
        getData(request)
    }
    
    func getAllPhotos(userId: String) {
        var constructor = urlConstructor
        constructor.path = "/method/photos.getAll"
        constructor.queryItems = requiredParameters + [
            URLQueryItem(name: "owner_id", value: userId),
        ]
        let request = URLRequest(url: constructor.url!)
        getData(request)
    }
    
    func getCommunitys(userId: String) {
        var constructor = urlConstructor
        constructor.path = "/method/groups.get"
        constructor.queryItems = requiredParameters + [
            URLQueryItem(name: "user_id", value: userId),
            URLQueryItem(name: "extended", value: "1"),
            URLQueryItem(name: "fields", value: "description"),
        ]
        let request = URLRequest(url: constructor.url!)
        getData(request)
    }
    
    func getCommunitysSearch(text: String) {
        var constructor = urlConstructor
        constructor.path = "/method/groups.search"
        constructor.queryItems = requiredParameters + [
            URLQueryItem(name: "q", value: text),
        ]
        let request = URLRequest(url: constructor.url!)
        getData(request)
    }
    
}
