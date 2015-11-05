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
  }
  
  func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
    locationLabel.text = "Location Not Available"
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
