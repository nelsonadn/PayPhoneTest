//
//  LocationService.swift
//  PayPhoneTest
//
//  Created by Nelson Cruz Mora on 20/6/26.
//  Copyright © 2026 Nelson Cruz Mora. All rights reserved.
//

import CoreLocation
import Foundation

final class LocationService: NSObject, CLLocationManagerDelegate, ObservableObject {
    @Published var latitude: String = ""
    @Published var longitude: String = ""
    @Published var authorizationMessage: String?

    private let manager = CLLocationManager()
    private var completion: ((Result<CLLocationCoordinate2D, Error>) -> Void)?

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.allowsBackgroundLocationUpdates = true
        manager.pausesLocationUpdatesAutomatically = true
    }

    func requestCurrentLocation() {
        let status = manager.authorizationStatus
        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            authorizationMessage = "Location Permission Denied"
        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()
        @unknown default:
            authorizationMessage = "Location Permission Denied"
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()
        case .restricted, .denied:
            authorizationMessage = "Location Permission Denied"
        case .notDetermined:
            break
        @unknown default:
            authorizationMessage = "Location Permission Denied"
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        latitude = String(format: "%.6f", location.coordinate.latitude)
        longitude = String(format: "%.6f", location.coordinate.longitude)
        authorizationMessage = nil
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        authorizationMessage = "Location Error"
    }
}
