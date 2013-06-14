//
//  LibLocation.m
//  myVita
//
//  Created by Marco Velluto on 26/03/13.
//  Copyright (c) 2013 Algos. All rights reserved.
//

#import "LibLocation.h"

@implementation LibLocation

/**
 Restituisce la localizzazione attuale.
 */
+ (CLLocation*)location
{
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    
    if ([CLLocationManager locationServicesEnabled]) {
        
        //Questo metodo chiede all'utente se l'app può essere localizzata.
        [locationManager startUpdatingLocation];
        locationManager.delegate = locationManager.delegate;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.distanceFilter = kCLDistanceFilterNone;
    }
    return [locationManager location];
}

/**
 Calcola la distanza tra la posizione attuale e la posizione passata
 */
+ (float)calcoloDistanza:(CLLocation *)location {
    
    float f = [[LibLocation location] distanceFromLocation:location];
    return f;
}

/**
 Calcola la distanza tra la posizione A e la posizione B
 */
+ (float)calcoloDistanzaWithALocation:(CLLocation *)aLocation andBLocation:(CLLocation *)bLocation{
    
    float f = [aLocation distanceFromLocation:bLocation];
    return f;
}


@end
