//
//  FormViewController.swift
//  MattKusak-VishalPuppala-MicahRounds-Final-Project
//
//  Created by Micah Rounds on 7/20/20.
//  Copyright © 2020 Micah Rounds. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase
import FirebaseStorage
class FormViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    @IBOutlet weak var formImage: UIImageView!
    @IBOutlet weak var eventTitle: UITextField!
    @IBOutlet weak var foodLoc: UITextField!
    @IBOutlet weak var endDate: UIDatePicker!
    @IBOutlet weak var eventDescription: UITextField!
    var imagePath:String = ""
    var coord:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var objID:Int = 0
    var fOpt:String = ""
    var formPoint:LocationPoint = LocationPoint(title: "", locationName: "", coordinate: CLLocationCoordinate2D(), date: Date(), subtitle: "",opt: "",path: "")
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func addImage(_ sender: Any) {
        let img = UIImagePickerController()
        img.delegate = self
        img.sourceType = UIImagePickerController.SourceType.savedPhotosAlbum
        self.present(img, animated: true)
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        if let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            formImage.image = img
            let imgdata = formImage.image?.pngData()
            let id = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child(id+".jpg")
            let uploadTask = storageRef.putData(imgdata!, metadata: nil) { (metadata, error) in
              guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                return
              }
              storageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                  print("error getting downloadurl")
                  return
                }
                self.imagePath = downloadURL.absoluteString
                //print(self.imagePath)
              }
            }
            
        }
        
        self.dismiss(animated: true)
    }
    @IBAction func addLocation(_ sender: Any) {
        if eventTitle.text != nil && foodLoc.text != nil && eventDescription.text != nil
        {
           let now = Date()
           let result = now.compare(endDate.date)
            //verify input date hasn't passed
            if result.rawValue == -1
            {
                //print(endDate.date)
                formPoint = LocationPoint(title: eventTitle.text!, locationName: foodLoc.text!, coordinate: coord, date: endDate.date, subtitle: eventDescription.text!,opt: fOpt,path: imagePath)
                
                //self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nvc = segue.destination as? UINavigationController
        let vc = nvc?.topViewController as? ViewController
        let db = Database.database().reference()
        db.child("locationPoints").childByAutoId().setValue(["long": Double(formPoint.coordinate.longitude), "date": formPoint.date.description, "lat": Double(formPoint.coordinate.latitude), "desc": formPoint.subtitle, "opt": formPoint.opt, "title": formPoint.title, "locationName": formPoint.locationName, "path":formPoint.path])
        //vc?.currPoint = formPoint
        //vc?.points.append(formPoint)
    }
    

}
