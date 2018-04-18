//
//  NoteDetailViewController+UILocation Management.swift
//  EverPobre
//
//  Created by Adolfo Fernández on 18/4/18.
//  Copyright © 2018 Adolfo Fernandez. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

extension NoteDetailViewController {
    
    @objc func addLocation()
    {
        mapView.isHidden =  !mapView.isHidden
    }

    
    // MARK: - Location Manage Methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        self.mapView.setCenter(location.coordinate, animated: true)
    }
    
   
}
