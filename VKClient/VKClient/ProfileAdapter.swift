//
//  ProfileAdapter.swift
//  VKClient
//
//  Created by Сергей Черных on 27.12.2021.
//

import Foundation
import RealmSwift

final class ProfileAdapter {
    
    private let networkService = NetworkService()
    private var realmNotificationToken: NotificationToken?
    
    func getProfiles(then completion: @escaping ([ProfileForAdapter]) -> Void) {
        guard let realm = try? Realm() else { return }
        let realmProfiles = realm.objects(RealmProfile.self)
        self.realmNotificationToken?.invalidate()
        
        let token = realmProfiles.observe { [weak self] changes in
            guard let self = self else { return }
            switch changes {
            case .update(let realmProfiles, _, _, _):
                var profiles: [ProfileForAdapter] = []
                profiles = realmProfiles.map { ProfileForAdapter(rlmProfile: $0) }
                self.realmNotificationToken?.invalidate()
                completion(profiles)
            case .error(let error):
                fatalError("\(error)")
            case .initial:
                var profiles: [ProfileForAdapter] = []
                profiles = realmProfiles.map { ProfileForAdapter(rlmProfile: $0) }
                self.realmNotificationToken?.invalidate()
                completion(profiles)
            }
        }
        self.realmNotificationToken = token
        
        
        networkService.getFriendsUrlRequest()
            .then(networkService.getFriendsData(with:))
            .then(networkService.parseFriends(json:))
            .then(networkService.parseFriendsToRealm(friends:))
            .done { try? RealmService.save(items: $0) }
            .catch { print($0) }
    }
}
