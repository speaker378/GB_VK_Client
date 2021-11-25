//
//  ParseDataGroupsOperation.swift
//  VKClient
//
//  Created by Сергей Черных on 25.11.2021.
//

import UIKit

final class ParseDataGroupsOperation: AsyncOperation {
    var groups: [Group]?
    
    override func main() {
        guard
            let fetchOperation = dependencies.first as? FetchDataGroupsOperation,
            let data = fetchOperation.result
        else {
            state = .finished
            return
        }
        
        do {
            self.groups = try JSONDecoder().decode(VKResponse<Group>.self, from: data).response.items
            state = .finished
        } catch  {
            print(error.localizedDescription)
            self.state = .finished
        }
        
        self.state = .finished
    }
}
