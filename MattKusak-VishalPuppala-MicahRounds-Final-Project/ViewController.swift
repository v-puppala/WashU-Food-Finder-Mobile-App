//
//  ViewController.swift
//  MattKusak-VishalPuppala-MicahRounds-Final-Project
//
//  Created by Micah Rounds on 7/20/20.
//  Copyright © 2020 Micah Rounds. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase
import CoreLocation
class ViewController: UIViewController, MKMapViewDelegate,UIGestureRecognizerDelegate,CLLocationManagerDelegate {

    @IBOutlet weak var optionSwitch: UISwitch!
    @IBOutlet weak var myMap: MKMapView!
    let locationManager = CLLocationManager()
    var points:[LocationPoint] = []
    var currCoord:CLLocationCoordinate2D = CLLocationCoordinate2D()
    var currPoint = LocationPoint(title: "", locationName: "", coordinate: CLLocationCoordinate2D(), date: Date(), subtitle: "",opt: "", path: "")
    var selctedPoint = LocationPoint(title: "", locationName: "", coordinate: CLLocationCoordinate2D(), date: Date(), subtitle: "",opt: "", path: "")
    var currColor:UIColor = .green
    var option:String = "free"
    override func viewDidLoad() {
        super.viewDidLoad()
         var mapRegion:MKCoordinateRegion = MKCoordinateRegion()
         let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude:38.6421713 , longitude: -90.3071533)
        mapRegion.center = coordinate
        mapRegion.span.latitudeDelta = 0.025
        mapRegion.span.longitudeDelta = 0.025
        myMap.delegate = self
        myMap.setRegion(mapRegion, animated: true)
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        // Do any additional setup after loading the view.
    }
    @IBAction func switchFoodOption(_ sender: Any) {
        if optionSwitch.isOn
        {
            option = "rare"
            // change to rare food option
        }
        else
        {
            option = "free"
            //change to free food option
        }
    }
    //enables tap handler for manually entered locations
    @IBAction func addLocation(_ sender: Any) {
        let gRecognizer = UITapGestureRecognizer(target: self, action:#selector(self.handleTap))
        gRecognizer.delegate = self
        myMap.addGestureRecognizer(gRecognizer)
    }
    @IBAction func userLocation(_ sender: Any) {
        
        performSegue(withIdentifier: "gotoform", sender: (Any).self)
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        currCoord = location.coordinate
    }
    /*
     takes user to form and holds on to coordinates associated with tap location on map
     */
    @objc func handleTap(gestureRecognizer: UITapGestureRecognizer) {
        locationManager.stopUpdatingLocation()
        //print("tap")
        let location = gestureRecognizer.location(in: myMap)
        //converts to coordinate
       currCoord = myMap.convert(location, toCoordinateFrom: myMap)
        performSegue(withIdentifier: "gotoform", sender: (Any).self)
        //adds location object as annotation
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotoform"
        {
            let form = segue.destination as? FormViewController
            form?.coord = currCoord
            form?.fOpt = option
        }
        else if segue.identifier == "gotodetail"
        {
            let detail = segue.destination as? EventDetailView
            detail?.detailLoc = selctedPoint
        }
        
        
    }
    static func formatDate(s: String) ->Date?
    {
        
       let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
        let date = dateFormatter.date(from:s)
        return date
    }
   override func viewWillAppear(_ animated: Bool) {
    let db = Database.database().reference()
    db.child("locationPoints").observeSingleEvent(of: .value)
        {(snapshot) in
            if let dbpoints = snapshot.value as? [String:[String:Any]]
            {
                for p in dbpoints
                {
                    let dict = p.value
                    let newTitle = dict["title"] as! String
                    let newLocation = dict["locationName"] as! String
                    let newLat = dict["lat"] as! Double
                    let newLong = dict["long"] as! Double
                    let newCoord = CLLocationCoordinate2D(latitude: newLat , longitude: newLong)
                    let newDate = dict["date"] as! String
                    let newDateObj = ViewController.formatDate(s: newDate)!
                    let newSubtitle = dict["desc"] as! String
                    let newOpt = dict["opt"] as! String
                    let newPath = dict["path"] as! String
                    let newLocationPoint = LocationPoint(title: newTitle, locationName: newLocation, coordinate:newCoord , date: newDateObj, subtitle: newSubtitle, opt: newOpt, path: newPath)
                    self.myMap.addAnnotation(newLocationPoint)
                }
            }
        }

    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKMarkerAnnotationView
        if pinView == nil {
            pinView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.rightCalloutAccessoryView = UIButton(type: .infoDark)
            let lp = annotation as? LocationPoint
            if lp!.opt == "free"
            {
                pinView!.markerTintColor = .green
            }
            else if lp!.opt == "rare"
            {
                pinView!.markerTintColor = .purple
            }
            else
            {
                pinView!.markerTintColor = .black
            }
           
            
            
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }

    /*func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
    }*/

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
                let ann = view.annotation as? LocationPoint
                let t = ann?.title
                let l = ann?.locationName
                let c = ann?.coordinate
                let d = ann?.date
                let s = ann?.subtitle
                let o = ann?.opt
                let p = ann?.path
                selctedPoint = LocationPoint(title: t!, locationName: l!, coordinate: c!, date: d!, subtitle: s!,opt: o!,path: p!)
                performSegue(withIdentifier: "gotodetail", sender: Any.self)
               
        }
      }
    

}

