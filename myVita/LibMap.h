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

/**
 Fa uno zoom PERONALIZZATO e permette di vedere sulla mappa i due punti passati.
 Mostra nella mappa i due punti A e B a qualunque distanza si trovino.
 */
+ (void)zoomMapMiddlePoint:(MKMapView *)mapView witLocationA:(CLLocation *)locationA withLocationB:(CLLocation *)locationB;

/**
 Mostra la mappa centrata sulla posione A
 */
+ (void)zoomMap:(MKMapView *)mapView centerIn:(CLLocation *)locationA andLocationB:(CLLocation *)locationB;
@end
