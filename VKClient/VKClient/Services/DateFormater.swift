//
//  DateFormater.swift
//  VKClient
//
//  Created by Сергей Черных on 10.11.2021.
//

import UIKit

extension Date {
    func timeAgoDisplay() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}
