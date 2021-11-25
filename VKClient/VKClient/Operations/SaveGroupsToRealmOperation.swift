//
//  SaveGroupsToRealmOperation.swift
//  VKClient
//
//  Created by Сергей Черных on 25.11.2021.
//

import UIKit
import RealmSwift

final class SaveGroupsToRealmOperation: AsyncOperation {
    override func main() {
        guard
            let parseDataGroupsOperation = dependencies.first as? ParseDataGroupsOperation,
            let groups = parseDataGroupsOperation.groups
        else {
            state = .finished
            return
        }
        
        let realmGroups = groups.map { RealmGroup(group: $0) }
        
        OperationQueue.main.addOperation {
            do {
                try RealmService.save(items: realmGroups)
                self.state = .finished
            }
            catch  {
                print(error.localizedDescription)
                self.state = .finished
            }
        }
    }
}
