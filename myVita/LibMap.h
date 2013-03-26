//
//  LibMap.h
//  myVita
//
//  Created by Marco Velluto on 26/03/13.
//  Copyright (c) 2013 Algos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface LibMap : NSObject

/**
 Fa uno zoom STANDARD (2000 - 2000) sulla mappa nel punto in cui ti trovi.
 */
+ (MKMapView *)zoomMap:(MKMapView *)mapView;

/**
 Fa uno zoom PERSONALIZZATO sulla mappa nel punto in cui ti trovi.
 */
+ (void)zoomMap:(MKMapView *)mapView withLatitudinalMeters:(double)latitudinalMeters andLongitudinalMeters:(double)longitudinalMeters;

/**
 Fa uno zoom PERSONALIZZATO sulla mappa nel punto passato tramite location.
 */
+ (void)zoomMap:(MKMapView *)mapView withLocation:(CLLocation *)location withLatitudinalMeters:(double)latitudinalMeters andLongitudinalMeters:(double)longitudinalMeters;

@end
