//
//  ViewController.swift
//  WhereIAM
//
//  Created by Guilherme Costa on 12/06/22.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var map: MKMapView!
    var locationManager = CLLocationManager()
    
    @IBOutlet weak var velocityLabel: UILabel!
    @IBOutlet weak var latLabel: UILabel!
    @IBOutlet weak var lngLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations.last!
        
        let lat = userLocation.coordinate.latitude
        let lng = userLocation.coordinate.longitude
        latLabel.text = String(lat)
        lngLabel.text = String(lng)
        
        velocityLabel.text = String(userLocation.speed)
        
        let deltaLat: CLLocationDegrees = 0.01
        let deltaLng: CLLocationDegrees = 0.01
        
        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat, lng)
        
        let exibitionArea: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: deltaLat, longitudeDelta: deltaLng)
        let region: MKCoordinateRegion = MKCoordinateRegion(center: location, span: exibitionArea)
        map.setRegion(region, animated: true)
        
        CLGeocoder().reverseGeocodeLocation(userLocation, completionHandler: { (placeDetail, err) in
            if err == nil {
                if let placeData = placeDetail?.first {
                    self.addressLabel.text = ""
                    if let subThoroughfare = placeData.subThoroughfare {
                        self.addressLabel.text = subThoroughfare
                    }
                    if let thoroughfare = placeData.thoroughfare {
                        self.addressLabel.text! += " \(thoroughfare)"
                    }
                    if let locality = placeData.locality {
                        self.addressLabel.text! += ", \(locality)"
                    }
                }
            }
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status != .authorizedWhenInUse {
            let handlerClosure = {(alertAction: UIAlertAction) in
                if let url = URL(string: UIApplication.openSettingsURLString) {
                   if UIApplication.shared.canOpenURL(url) {
                       UIApplication.shared.open(url, options: [:], completionHandler: nil)
                   }
                }
            }
            let configAction = UIAlertAction(title: "Abrir configurações", style: .default, handler: handlerClosure)
            let cancelAction = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
            
            let alertController = Message.alert(title: "Permissão de localização", message: "Necessário permissão para sua localização! Por favor habilite.", actions: [configAction, cancelAction])
            
            present(alertController, animated: true, completion: nil)
        }
    }


}

