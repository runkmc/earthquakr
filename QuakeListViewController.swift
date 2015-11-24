//
//  QuakeListViewController.swift
//  Earthquakr
//
//  Created by Kevin McGladdery on 11/4/15.
//  Copyright © 2015 Kevin McGladdery. All rights reserved.
//

import UIKit
import CoreLocation
import DZNEmptyDataSet
import Colortools

class QuakeListViewController: UIViewController, CLLocationManagerDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate  {

  var quakeList: QuakeList?
  let manager = CLLocationManager()
  var loc = CLLocation()
  let refresh = UIRefreshControl()
  @IBOutlet weak var locationLabel: UILabel!
  @IBOutlet weak var tableView: UITableView!
  
  func askForLocation() {
    locationLabel.text = "Getting Location..."
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
      locationLabel.text = "Getting Location..."
    } else {
      locationLabel.text = "Location Services Disabled"
    }
  }
  
  func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let location = locations.last
    guard let currentLocation = location else {
      locationLabel.text = "Could not get location"
      self.refresh.endRefreshing()
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
      self.refresh.endRefreshing()
      self.tableView.reloadData()
    })
    getter.getQuakes()
  }
  
  func sensitivity() -> Double {
    guard let highSensitivity = NSUserDefaults.standardUserDefaults().objectForKey("highSensitivity") else {
      return 2.9
    }
    if highSensitivity as! Bool {
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
      if let city = place.locality, let state = place.administrativeArea {
        self.locationLabel.text = "\(city), \(state)"
        return
      }
      if let area = place.administrativeArea {
        self.locationLabel.text = area
        return
      } else { self.locationLabel.text = "" }
    })
  }
  
  func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
    locationLabel.text = "Could not get location"
  }
  
  func refreshPulled() {
    refresh.beginRefreshing()
    self.askForLocation()
  }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.emptyDataSetDelegate = self
        self.tableView.emptyDataSetSource = self
        self.tableView.tableFooterView = UIView()
        manager.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        self.askForLocation()
        tableView.addSubview(refresh)
        refresh.addTarget(self, action: Selector("refreshPulled"), forControlEvents: .ValueChanged)
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
  
  func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
    let text = "No Nearby Earthquakes"
    let attribs = [NSFontAttributeName: UIFont.boldSystemFontOfSize(18),
      NSForegroundColorAttributeName: UIColor.darkGrayColor()]
    return NSAttributedString(string: text, attributes: attribs)
  }
  
  func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
    let text = "Feel free to ride that unicycle or eat that precariously stacked ice cream cone!"
    let lightGrey = UIColor.darkGrayColor().lighten(0.2)!
    let attribs = [NSFontAttributeName: UIFont.systemFontOfSize(14),
      NSForegroundColorAttributeName: lightGrey]
    return NSAttributedString(string: text, attributes: attribs)
  }
  
  func buttonTitleForEmptyDataSet(scrollView: UIScrollView!, forState state: UIControlState) -> NSAttributedString! {
    let text = "Check for Earthquakes"
    let attribs = [NSFontAttributeName: UIFont.boldSystemFontOfSize(14),
      NSForegroundColorAttributeName: UIColor.init(hex: 0xD55235FF)]
    return NSAttributedString(string: text, attributes: attribs)
  }
  
  func emptyDataSetDidTapButton(scrollView: UIScrollView!) {
    self.askForLocation()
  }
  
  func verticalOffsetForEmptyDataSet(scrollView: UIScrollView!) -> CGFloat {
    return -70.0
  }
  
  func emptyDataSetShouldAllowScroll(scrollView: UIScrollView!) -> Bool {
    return true
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