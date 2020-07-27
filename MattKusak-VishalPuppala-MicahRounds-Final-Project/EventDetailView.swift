//
//  EventDetailView.swift
//  MattKusak-VishalPuppala-MicahRounds-Final-Project
//
//  Created by Micah Rounds on 7/21/20.
//  Copyright © 2020 Micah Rounds. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase
/*extension UIViewController{
    func pushKeyboard(){
        let touchObject: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(keyboardRetreat) )
        view.addGestureRecognizer(touchObject)
        
      
        
    }
    @objc func keyboardRetreat(){
                 view.endEditing(true)
              }
}*/
class EventDetailView: UIViewController {
    var detailLoc: LocationPoint = LocationPoint(title: "", locationName: "", coordinate: CLLocationCoordinate2D(), date: Date(), subtitle: "",opt: "", path: "",id:"",score: 0)
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var foodImage: UIImageView!
  
    @IBOutlet weak var legitLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
           
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        //I used this article for the DateFormatter()
        let db = Database.database().reference()
        db.root.child("locationPoints").child(detailLoc.id).observe(.value)
        {(snapshot) in
            if let sc = snapshot.value as? [String:Any]
            {
                let s = sc["score"] as! Int
                self.legitLabel.text = "Legitness score: "+String(s)
            }
            else
            {
                self.legitLabel.text = "Legitness score: 0"
            }
        }
        //https://stackoverflow.com/questions/35700281/date-format-in-swift
        let df = DateFormatter()
        df.dateFormat = "E d MMM y, h:mm a"
        titleLabel.text = detailLoc.title
        locLabel.text = detailLoc.locationName
        endDateLabel.text = "Lasts Until: "+df.string(from: detailLoc.date)
        descriptionLabel.text = detailLoc.subtitle
        if let url = URL(string: detailLoc.path)
        {
            if let imageData = try? Data(contentsOf: url)
            {
                foodImage.image = UIImage(data: imageData)
            }
        }
        
    }
    //https://www.youtube.com/watch?v=YA20F7RJnwA was consulted for viewDidLayoutSubviews() function
    
    
    @IBAction func upvote(_ sender: Any) {
        let db = Database.database().reference()
        detailLoc.score += 1
        db.root.child("locationPoints").child(detailLoc.id).updateChildValues(["score":detailLoc.score])
        legitLabel.text = "Legitness score: "+String(detailLoc.score)

    }
    
    @IBAction func downvote(_ sender: Any) {
        let db = Database.database().reference()
        detailLoc.score -= 1
        db.root.child("locationPoints").child(detailLoc.id).updateChildValues(["score":detailLoc.score])
        legitLabel.text = "Legitness score: "+String(detailLoc.score)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
