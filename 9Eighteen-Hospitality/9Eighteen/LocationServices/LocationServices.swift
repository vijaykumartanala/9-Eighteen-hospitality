//
//  LocationServices.swift
//  9Eighteen
//
//  Created by Vijaykumar Tanala on 09/08/20.
//  Copyright © 2020 vijaykumar Tanala. All rights reserved.
//

import UIKit
import CoreLocation

struct UserConstants {
    static let latitude = "latitude"
    static let longitude = "longitude"
    static let lastKnownLatitude = "lastKnownLatitude"
    static let lastKnownLongitude = "lastKnownLongitude"
}

@objc protocol LocationManagerDelegate {
  @objc optional func getLocation(location: CLLocation,isLocationfetched:Bool)
}

class LocationServices: NSObject,CLLocationManagerDelegate {

    weak var locationManagerDelegate: LocationManagerDelegate?
    var isLocationfetched: Bool = false
    var lastKnownLocation: CLLocation? {
        get {
            let latitude = UserDefaults.standard.double(forKey: UserConstants.lastKnownLatitude)
            let longitude = UserDefaults.standard.double(forKey: UserConstants.lastKnownLongitude)

            if latitude.isZero || longitude.isZero {
                return nil
            }
            return CLLocation(latitude: latitude, longitude: longitude)
        }
        set {
            UserDefaults.standard.set(newValue?.coordinate.latitude ?? 0, forKey: UserConstants.lastKnownLatitude)
            UserDefaults.standard.set(newValue?.coordinate.longitude ?? 0, forKey: UserConstants.lastKnownLongitude)
            UserDefaults.standard.synchronize()
        }
    }

    struct SharedInstance {
        static let instance = LocationServices()
    }

    class var shared: LocationServices {
        return SharedInstance.instance
    }

    enum Request {
        case requestWhenInUseAuthorization
        case requestAlwaysAuthorization
    }

    var clLocationManager = CLLocationManager()

    func setAccuracy(clLocationAccuracy: CLLocationAccuracy) {
        clLocationManager.desiredAccuracy = clLocationAccuracy
    }

    var isLocationEnable: Bool = false {
        didSet {
            if !isLocationEnable {
                lastKnownLocation = nil
            }
        }
    }
    
    func startUpdatingLocation() {
        isLocationfetched = false
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined:
                clLocationManager.delegate = self
                self.clLocationManager.startUpdatingLocation()
                clLocationManager.requestWhenInUseAuthorization()
                clLocationManager.desiredAccuracy = kCLLocationAccuracyBest
                clLocationManager.distanceFilter = 50
                clLocationManager.allowsBackgroundLocationUpdates = true
                isLocationEnable = true
            case .restricted, .denied:
                showLocationAccessAlert()
                isLocationEnable = false
            case .authorizedAlways, .authorizedWhenInUse:
                self.clLocationManager.delegate = self
                self.clLocationManager.startUpdatingLocation()
                isLocationEnable = true
            default:
                print("Invalid AuthorizationStatus")
            }
        } else {
            isLocationEnable = false
            showLocationAccessAlert()
        }
    }
    
      func showLocationAccessAlert() {
            let alertController = UIAlertController(title: "Location Permission is required", message: "Please share the location from settings to be able to use the app and order food and beverages from 9- Eighteen.", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "Settings", style: .default, handler: {(cAlertAction) in
                UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!)
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {(cAlertAction) in
                if let delegate = self.locationManagerDelegate {
                    delegate.getLocation!(location:CLLocation(latitude: 0.0, longitude: 0.0) , isLocationfetched:false)
                }
            })
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            let appdelegate = UIApplication.shared.delegate as? AppDelegate
            appdelegate?.window?.rootViewController?.present(alertController, animated: true, completion: nil)
        }

        func stopUpdatingLocation() {
            self.clLocationManager.stopUpdatingLocation()
        }

        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            if !isLocationfetched {
                isLocationfetched = true
                clLocationManager.startMonitoringSignificantLocationChanges()
            }
            let userLocation = locations[0] as CLLocation
            self.lastKnownLocation = userLocation
            if let delegate = self.locationManagerDelegate {
                delegate.getLocation!(location: userLocation ,isLocationfetched:true)
            }
        }

        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            if (status == CLAuthorizationStatus.denied) {
                isLocationEnable = false
            } else if (status == CLAuthorizationStatus.authorizedWhenInUse) {
                //The user accepted authorization
                self.clLocationManager.delegate = self
                self.clLocationManager.startUpdatingLocation()
                clLocationManager.desiredAccuracy = kCLLocationAccuracyBest
                clLocationManager.distanceFilter = 50
                clLocationManager.allowsBackgroundLocationUpdates = true
                isLocationEnable = true
            }
        }

        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            if let delegate = self.locationManagerDelegate {
                delegate.getLocation!(location:CLLocation(latitude: 0.0, longitude: 0.0) , isLocationfetched:false)
            }
            print("\n error description for location updation:- \(error.localizedDescription)")
        }

    }

