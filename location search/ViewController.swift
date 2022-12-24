//
//  ViewController.swift
//  location search
//
//  Created by Admin on 24/12/22.
//

import UIKit
import MapKit
import FloatingPanel
import CoreLocation

class ViewController: UIViewController, SearchViewControllerDelegate {
    
    let mapView = MKMapView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mapView)
        title = "Search"
        
        let searchVC = SearchViewController()
        searchVC.delegate = self
        let panel = FloatingPanelController()
        panel.set(contentViewController: SearchViewController())
        panel.addPanel(toParent: self)
    }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mapView.frame = view.bounds
    }
    
    func searchViewController(_ vc: SearchViewController, didSelectLocationwith coordinate: CLLocationCoordinate2D?) {
        mapView.removeAnnotations(mapView.annotations)
        
        guard let coordinate = coordinate else {
            return
        }
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        mapView.addAnnotation(pin)
        
        mapView.setRegion(MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.7, longitudeDelta: 0.7)), animated: true)
        
    }


}

