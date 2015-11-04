//
//  QuakeGetter.swift
//  Earthquakr
//
//  Created by Kevin McGladdery on 11/2/15.
//  Copyright © 2015 Kevin McGladdery. All rights reserved.
//

import Foundation
import CoreLocation
import SwiftyJSON
import Alamofire

class QuakeGetter {
  var quakes: [Quake] = []
  var parameters: [String: String]
  
  init(parameters: [String: String]) {
    self.parameters = parameters
    self.parameters["format"] = "geojson"
    self.parameters["starttime"] = self.parameters["starttime"] ?? {
      return quakeRequestDateFormatter(twelveHoursAgo(date: NSDate()))
      }()
   
    Alamofire.request(.GET, "http://earthquake.usgs.gov/fdsnws/event/1/query", parameters: self.parameters).responseJSON { response in
      self.handleJson(JSON(data: response.data!).dictionary!)
      }
    }
  
  func handleJson(json: [String: JSON]) {
    for result in json["features"]!.arrayValue {
      let magnitude = result["properties"]["mag"].doubleValue
      let locationString = result["properties"]["place"].stringValue
      let rawTime = result["properties"]["time"].stringValue
      let url = result["properties"]["url"].stringValue
      let coords = result["geometry"]["coordinates"].arrayValue
      let coordinates:[Double] = coords.map {$0.doubleValue}
      
      let q = Quake(magnitude: magnitude, locationString: locationString, rawTime: Int(rawTime)!,
        url: url, coordinates: coordinates)
      self.quakes.append(q)
    }
  }
}