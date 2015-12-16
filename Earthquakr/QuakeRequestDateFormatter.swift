//
//  QuakeRequestDateFormatter.swift
//  Earthquakr
//
//  Created by Kevin McGladdery on 11/2/15.
//  Copyright © 2015 Kevin McGladdery. All rights reserved.
//

import Foundation

func quakeRequestDateFormatter(date:NSDate) -> String {
  let formatter = NSDateFormatter()
  formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
  formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
  
  return formatter.stringFromDate(date)
}

func xHoursAgo(x: Double)(date: NSDate) -> NSDate {
  let calendar = NSCalendar.currentCalendar()
  return calendar.dateByAddingUnit(.Hour, value: Int(-x), toDate: date, options: [])!
}

let twelveHoursAgo = xHoursAgo(12)