//
//  QuakeListViewController.swift
//  Earthquakr
//
//  Created by Kevin McGladdery on 11/4/15.
//  Copyright © 2015 Kevin McGladdery. All rights reserved.
//

import UIKit
import CoreLocation

class QuakeListViewController: UIViewController, CLLocationManagerDelegate {

  var quakeList: QuakeList?
  let manager = CLLocationManager()
  @IBOutlet weak var locationLabel: UILabel!
  @IBOutlet weak var tableView: UITableView!
  
  func askForLocation() {
    manager.delegate = self
    manager.requestWhenInUseAuthorization()
    let status = CLLocationManager.authorizationStatus()
    
    if (status == .AuthorizedAlways || status == .AuthorizedWhenInUse) {
      manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
      manager.requestLocation()
    } else {
      locationLabel.text = "Location Services Disabled"
    }
  }
  
  func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
    if status == .AuthorizedAlways || status == .AuthorizedWhenInUse {
      locationLabel.text = "Getting Location"
    } else {
      locationLabel.text = "Location Services Disabled"
    }
  }
  
  func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let location = locations.last
    print(location?.coordinate.latitude)
    print(location?.coordinate.longitude)
    guard let currentLocation = location else {
      locationLabel.text = "Could not get location"
      return
      }
    self.updateLocationLabel(currentLocation)
    var params: [String: String] = ["latitude": String(currentLocation.coordinate.latitude)]
    params["longitude"] = String(currentLocation.coordinate.longitude)
    params["maxradiuskm"] = "2000"
    params["minmagnitude"] = "1.2"
    let _ = QuakeGetter(parameters: params, completion: { quakes in
      let qlist = QuakeList(quakes: quakes, location: currentLocation, minNumber: 2.2)
      self.quakeList = qlist
    })
  }
  
  func updateLocationLabel(currentLocation: CLLocation) {
    let coder = CLGeocoder()
    coder.reverseGeocodeLocation(currentLocation, completionHandler: { results in
      guard let mark = results.0 else {
        self.locationLabel.text = "\(currentLocation.coordinate.latitude), \(currentLocation.coordinate.longitude)"
        return
      }
      guard let place = mark.first else {
        self.locationLabel.text = "\(currentLocation.coordinate.latitude), \(currentLocation.coordinate.longitude)"
        return
      }
      if let city = place.locality {
        self.locationLabel.text = city
        return
      }
      if let area = place.administrativeArea {
        self.locationLabel.text = area
        return
      }
    })
    
  }
  
  func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
    locationLabel.text = "Could not get location"
  }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.askForLocation()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
