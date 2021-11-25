//
//  FetchDataGroupsOperation.swift.swift
//  VKClient
//
//  Created by Сергей Черных on 25.11.2021.
//

import UIKit

final class FetchDataGroupsOperation: AsyncOperation {
    var result: Data?
    private let session = URLSession.shared
    
    private func url(from path: String, params: [String: String]) -> URL {
        var components = URLComponents()
        components.scheme = APIConstants.shared.scheme
        components.host = APIConstants.shared.host
        components.path = path
        components.queryItems = params.map { URLQueryItem(name: $0, value: $1) }
        components.queryItems! += [
            URLQueryItem(name: "access_token", value: Session.shared.token),
            URLQueryItem(name: "v", value: APIConstants.shared.versionAPI),
        ]
        return components.url!
    }
    
    override func main() {
        guard !isCancelled else { return }
        
        let path = "/method/groups.get"
        let params = [
            "user_id" : String(Session.shared.userId),
            "extended" : "1",
        ]
        let url = url(from: path, params: params)
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) { responseData, urlResponse, error in
            guard let response = urlResponse as? HTTPURLResponse,
                  (200...299).contains(response.statusCode),
                  error == nil,
                  let data = responseData
            else { return }
            
            self.result = data
            self.state = .finished
        }
        
        task.resume()
    }
    
}
