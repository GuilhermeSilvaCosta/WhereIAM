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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
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

