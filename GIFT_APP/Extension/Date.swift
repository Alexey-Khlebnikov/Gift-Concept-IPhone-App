//
//  Date.swift
//  GIFT_APP
//
//  Created by Alguz on 11/28/19.
//  Copyright © 2019 Leo Suzin. All rights reserved.
//

import Foundation

extension Date {

    var time: String { return Formatter.time.string(from: self) }

    var year:    Int { return Calendar.autoupdatingCurrent.component(.year,   from: self) }
    var month:   Int { return Calendar.autoupdatingCurrent.component(.month,  from: self) }
    var day:     Int { return Calendar.autoupdatingCurrent.component(.day,    from: self) }

    var elapsedTime: String {
        if timeIntervalSinceNow > -60.0  { return "Just Now" }
        if isInToday                 { return "Today at \(time)" }
        if isInYesterday             { return "Yesterday at \(time)" }
        return (Formatter.dateComponents.string(from: Date().timeIntervalSince(self)) ?? "") + " ago"
    }
    var isInToday: Bool {
        return Calendar.autoupdatingCurrent.isDateInToday(self)
    }
    var isInYesterday: Bool {
        return Calendar.autoupdatingCurrent.isDateInYesterday(self)
    }
    
    var localDateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }
    
    var localTimeString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        return dateFormatter.string(from: self)
    }
}
