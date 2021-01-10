//
//  DateExtension.swift
//  Days
//
//  Created by Jiaqi Feng on 1/9/21.
//

import Foundation

extension Date {
    var month: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: self)
    }
}
