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
  var loc = CLLocation()
  @IBOutlet weak var locationLabel: UILabel!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var earthquakesLabel: UILabel!
  
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
    guard let currentLocation = location else {
      locationLabel.text = "Could not get location"
      return
      }
    self.loc = currentLocation
    self.updateLocationLabel(currentLocation)
    var params: [String: String] = ["latitude": String(currentLocation.coordinate.latitude)]
    params["longitude"] = String(currentLocation.coordinate.longitude)
    params["maxradiuskm"] = "2000"
    params["minmagnitude"] = "1.9"
    let getter = QuakeGetter(parameters: params, completion: { quakes in
      let qlist = QuakeList(quakes: quakes, location: currentLocation, minNumber: self.sensitivity())
      self.quakeList = qlist
      let numberOfQuakes = qlist.quakeViewModels.count
      if numberOfQuakes == 1 {
        self.earthquakesLabel.text = "1 Earthquake"
      } else {
        self.earthquakesLabel.text = "\(numberOfQuakes) Earthquakes"
      }
      self.tableView.reloadData()
    })
    getter.getQuakes()
  }
  
  func sensitivity() -> Double {
    let highSensitivity = NSUserDefaults.standardUserDefaults().objectForKey("highSensitivity") as! Bool
    if highSensitivity {
      return 1.9
    } else {
      return 2.9
    }
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
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      guard let cell = sender as! QuakeCell! else {
        return
      }
      let dvc = segue.destinationViewController as! QuakeDetailViewController
      dvc.quake = cell.quake
      dvc.currentLocation = self.loc
    }
}

extension QuakeListViewController: UITableViewDelegate {
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 55.0
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }
}

extension QuakeListViewController: UITableViewDataSource {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.quakeList?.quakeViewModels.count ?? 0
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("quakecell") as! QuakeCell
    
    cell.magnitudeLabel.text = self.quakeList?.quakeViewModels[indexPath.row].magnitudeString
    cell.timeLabel.text = self.quakeList?.quakeViewModels[indexPath.row].time
    cell.placeLabel.text = self.quakeList?.quakeViewModels[indexPath.row].locationString
    cell.quake = self.quakeList?.quakeViewModels[indexPath.row]
    
    return cell
  }
}