//
//  LocationService.swift
//  PayPhoneTest
//
//  Created by Nelson Cruz Mora on 20/6/26.
//  Copyright © 2026 Nelson Cruz Mora. All rights reserved.
//

import CoreLocation
import Combine
import Foundation

final class LocationService: NSObject, CLLocationManagerDelegate, ObservableObject {
    @Published var latitude: String = ""
    @Published var longitude: String = ""
    @Published var alertMessage: String?

    private let manager = CLLocationManager()

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.pausesLocationUpdatesAutomatically = true
    }

    func requestCurrentLocation() {
        guard CLLocationManager.locationServicesEnabled() else {
            alertMessage = "Location Services Disabled"
            return
        }

        let status = manager.authorizationStatus
        switch status {
        case .notDetermined:
            DispatchQueue.main.async { [manager] in
                manager.requestWhenInUseAuthorization()
            }
        case .restricted, .denied:
            alertMessage = "Location Permission Denied"
        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()
        @unknown default:
            alertMessage = "Location Permission Denied"
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()
        case .restricted, .denied:
            alertMessage = "Location Permission Denied"
        case .notDetermined:
            break
        @unknown default:
            alertMessage = "Location Permission Denied"
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()
        case .restricted, .denied:
            alertMessage = "Location Permission Denied"
        case .notDetermined:
            break
        @unknown default:
            alertMessage = "Location Permission Denied"
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        latitude = String(format: "%.6f", location.coordinate.latitude)
        longitude = String(format: "%.6f", location.coordinate.longitude)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        alertMessage = "Location Error"
    }
}
