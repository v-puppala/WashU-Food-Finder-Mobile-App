//
//  FormViewController.swift
//  MattKusak-VishalPuppala-MicahRounds-Final-Project
//
//  Created by Micah Rounds on 7/20/20.
//  Copyright © 2020 Micah Rounds. All rights reserved.
//

import UIKit
import MapKit
class FormViewController: UIViewController {
    @IBOutlet weak var eventTitle: UITextField!
    @IBOutlet weak var foodLoc: UITextField!
    @IBOutlet weak var endDate: UIDatePicker!
    @IBOutlet weak var eventDescription: UITextField!
    var coord:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var objID:Int = 0
    var fOpt:String = ""
    var formPoint:LocationPoint = LocationPoint(title: "", locationName: "", coordinate: CLLocationCoordinate2D(), date: Date(), subtitle: "",opt: "")
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func addLocation(_ sender: Any) {
        if eventTitle.text != nil && foodLoc.text != nil && eventDescription.text != nil
        {
           let now = Date()
           let result = now.compare(endDate.date)
            //verify input date hasn't passed
            if result.rawValue == -1
            {
                print(endDate.date)
                formPoint = LocationPoint(title: eventTitle.text!, locationName: foodLoc.text!, coordinate: coord, date: endDate.date, subtitle: eventDescription.text!,opt: fOpt)
                
                //self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nvc = segue.destination as? UINavigationController
        let vc = nvc?.topViewController as? ViewController
        vc?.currPoint = formPoint
        vc?.points.append(formPoint)
    }
    

}
