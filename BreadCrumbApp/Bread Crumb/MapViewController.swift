//
//  MapViewController.swift
//  Bread Crumb
//
//  Created by Andrew Olson on 10/4/16.
//  Copyright © 2016 Valhalla Applications. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation



class MapViewController: CoreDataViewController, MKMapViewDelegate,CLLocationManagerDelegate
{
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var placeBreadCrumbButton: UIButton!
    let locationManager = CLLocationManager()
    var pinSelected: BreadPin!
    var polyline = MKPolyline()
    
    let noteViewConrollerIdentifier = "NoteViewController"
    let imageViewControllerIdentifier = "ImageViewController"

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Map"
        mapView.delegate = self
        setUpLocationManager()
        setPressGestureRecognizer()
        addPins()
        mapView.userLocation.title = nil
        placeBreadCrumbButton.isEnabled = false
    }
    override func viewWillAppear(_ animated: Bool) {
        removeSelectedAnnotations()
    }
    
    @IBAction func placeBreadCrumb(_ sender: UIButton)
    {
        let coordinate = mapView.userLocation.coordinate
        //set the region
        let region = MKCoordinateRegion(center: coordinate,span: MKCoordinateSpan(latitudeDelta: 0.005,longitudeDelta: 0.005))
        mapView.setRegion(region, animated: true)

        //        create a usable annotation from the coordinates
        performInBackGround()
        {
            //Safer to create the Pin in the background
            let annotation = self.createPinAnnotation(coordinate: coordinate)
                    performUIUpdatesOnMain()
                    {
                        self.mapView.addAnnotation(annotation)
                    }
                }
    }
    @IBAction func clearAction(_ sender: UIBarButtonItem) {
        let pins = fetchPins()
        if !pins.isEmpty
        {
            performInBackGround {
                for pin in pins
                {
                    self.context.delete(pin)
                }
                self.save()
            }
        }
        let annotations = mapView.annotations
        mapView.removeAnnotations(annotations)
    }
    
//  On LongPress Gesture Recogniser for creating pins
    func setPressGestureRecognizer()
    {
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.onLongPressMapView(gestureRecognizer:)))
        mapView.addGestureRecognizer(longPressRecognizer)
    }
//  Create a car Pin
    func createPinAnnotation(coordinate: CLLocationCoordinate2D)->BreadPin
    {
        let annotation = BreadPin(coordinate: coordinate)
        
        return annotation
    }
//  Remove all selected Annotations
    func removeSelectedAnnotations() {
        
        mapView.selectedAnnotations = []
    }
    func onLongPressMapView(gestureRecognizer: UILongPressGestureRecognizer) {
        
        performInBackGround(){
            if gestureRecognizer.state == .began
            {
                //get the location of the press
                let location = gestureRecognizer.location(in: self.mapView)
                
                //convert that into usable coordinates
                let coordinate = self.mapView.convert(location, toCoordinateFrom: self.mapView)
                
                //create a usable annotation from the coordinates
                let annotation = self.createPinAnnotation(coordinate: coordinate)
                performUIUpdatesOnMain()
                {
                        self.mapView.addAnnotation(annotation)
                }
            }
        }
    }
    /*MARK - MapView Delegate */
    //customize the annotation
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? BreadPin
        {
            let reuseId = "pin"
            var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
            let pinImage = UIImage(named: "BreadPin")
            let size = CGSize(width: 25,height: 50)
            UIGraphicsBeginImageContext(size)
            pinImage?.draw(in: CGRect(x: 0,y:0,width: size.width ,height: size.height))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            
            if pinView == nil {
                pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                pinView!.image = resizedImage
                pinView!.tintColor = UIColor.red
                pinView!.canShowCallout = false
                pinView!.isEnabled = true
            }
            return pinView
        }
        
        
        return nil
    }
    //click event on Annotation
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("DidSelectAnnotation")
        
        if let pin = view.annotation as? BreadPin
        {
            print("Pin Touched")
            pinSelected = pin
            displayActionSheet(title: "", message: "", actions: actionBulder())
        }
    }
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        for pinView in views
        {
            let endFrame = pinView.frame
            pinView.frame = endFrame.offsetBy(dx: 0, dy: -500)
            UIView.animate(withDuration: 0.5, animations: {
                pinView.frame = endFrame
            })
        
        }
    
    }
    func addPins()
    {
        let pins = fetchPins()
        for pin in pins
        {
            let annotation = BreadPin(pin: pin)
            mapView.addAnnotation(annotation)
        }
    }
    
    //MARK: - Location Manager Delegate
    func setUpLocationManager()
    {
        //set the Location Manager Delegate
        locationManager.delegate = self
        //set the accuracy of the manager: This is the best that maps can provide,
        //intended for navigation aplications only
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.requestWhenInUseAuthorization()
        //start updating the users location
        locationManager.startUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //get the most recient location
        let location = locations.last
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude,
                                            longitude: location!.coordinate.longitude)
        //set the region
        let region = MKCoordinateRegion(center: center,span: MKCoordinateSpan(latitudeDelta: 0.005,longitudeDelta: 0.005))
        mapView.setRegion(region, animated: true)
        //stop the updating
        locationManager.stopUpdatingLocation()
        
        placeBreadCrumbButton.isEnabled = true
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        displayErrorAlert(message: error.localizedDescription)

    }

    //MARK: PrepareForSeque
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        save()
        if segue.identifier == noteViewConrollerIdentifier
        {
            if let controller = segue.destination as? NoteViewController
            {
                controller.pin = pinSelected.pin
            }
            else
            {
                print("Bad Seque.")
            }
        }
        else if segue.identifier == imageViewControllerIdentifier
        {
            if let controller = segue.destination as? ImageViewController
            {
                controller.pin = pinSelected.pin
            }
            else
            {
                print("Bad Seque.")
            }
        }
//        else if segue.identifier == appleMapsWebViewIdentifier
//        {
//            if let controller = segue.destination as? AppleMapsWebViewController
//            {
//                let latitude = pinSelected.coordinate.latitude
//                let longitude = pinSelected.coordinate.longitude
//                let urlString = "https://maps.apple.com/?daddr=\(latitude),\(longitude)"
//                controller.urlstring = urlString
//            }
//        }
    }

    //UIActionSheet Action Builder
    func actionBulder()->([UIAlertAction])
    {
      
        removeSelectedAnnotations()
        //Create actions for Alert ActionSheet
        let noteAction = UIAlertAction(title: "Take Notes",style: .default)
        {
            action in
            self.performSeque(identifier: self.noteViewConrollerIdentifier)
        }
        let photoAction = UIAlertAction(title: "Snapshot",style: .default)
        {
            action in
            self.performSeque(identifier: self.imageViewControllerIdentifier)
        }
        let navigationAction = UIAlertAction(title: "Start Navigation",style: .default)
        {
            action in
            //Thank you Apple!
            let latitude = self.pinSelected.coordinate.latitude
            let longitude = self.pinSelected.coordinate.longitude
            let urlString = "https://maps.apple.com/?daddr=\(latitude),\(longitude)"
            let client = URLClient.getShareInstance()
            client.openURL(urlString: urlString)
        }
        let deleteAction = UIAlertAction(title: "Delete Crumb",style: .destructive)
        {
            action in
            self.deletePin(pin: self.pinSelected.pin!)
            self.mapView.removeAnnotation(self.pinSelected)
        }
        let cancelAction = UIAlertAction(title: "Cancel",style: .cancel, handler: nil)
            let actions = [navigationAction, photoAction,noteAction,deleteAction, cancelAction]
        return (actions)
    }
    func performSeque(identifier: String)
    {
        performUIUpdatesOnMain()
        {
            self.performSegue(withIdentifier: identifier, sender: self)
        }
    }
}
