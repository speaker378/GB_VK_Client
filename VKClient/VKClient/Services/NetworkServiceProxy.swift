//
//  NetworkServiceProxy.swift
//  VKClient
//
//  Created by Сергей Черных on 21.02.2022.
//

import Foundation
import PromiseKit

class NetworkServiceProxy: NetworkServiceInterface {
    let networkService: NetworkService

    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    func getAuthorizeRequest() -> URLRequest {
        print("\n called function \(#function)")
        return self.networkService.getAuthorizeRequest()
    }

    func getNewsFeed(startTime: Int?, startFrom: String?, completion: @escaping ([NewsPublication], String?) -> Void) {
        self.networkService.getNewsFeed(startTime: startTime, startFrom: startFrom, completion: completion)
        print("\n called function \(#function) with arguments: startTime = \(String(describing: startTime)), startFrom = \(String(describing: startFrom))")
    }

    func getFriendsData(with request: URLRequest) -> Promise<Data> {
        print("\n called function \(#function)")
        return self.networkService.getFriendsData(with: request)
    }

    func getAllPhotos(userId: Int, completion: @escaping () -> Void) {
        self.networkService.getAllPhotos(userId: userId, completion: completion)
        print("\n called function \(#function)")
    }

    func likePhoto(ownerID: Int, itemID: Int, action: LikeAction) {
        self.networkService.likePhoto(ownerID: ownerID, itemID: itemID, action: action)
        print("\n called function \(#function)")
    }

    func getGroupsSearch(text: String, completion: @escaping ([Group]) -> Void) {
        self.networkService.getGroupsSearch(text: text, completion: completion)
        print("\n called function \(#function)")
    }

    func groupMembershipAction(groupID: Int, action: GroupMembershipAction) {
        self.networkService.groupMembershipAction(groupID: groupID, action: action)
        print("\n called function \(#function)")
    }


}
