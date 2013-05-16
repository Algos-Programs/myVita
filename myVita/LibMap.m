//
//  LibMap.m
//  myVita
//
//  Created by Marco Velluto on 26/03/13.
//  Copyright (c) 2013 Algos. All rights reserved.
//

#import "LibMap.h"
#import "LibLocation.h"

@implementation LibMap

/**
    Fa uno zoom STANDARD (2000 - 2000) sulla mappa nel punto in cui ti trovi.
 */
+ (MKMapView *)zoomMap:(MKMapView *)mapView {
    
    CLLocation *location = [LibLocation location];
    CLLocationCoordinate2D coordinate2D = [location coordinate];
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(coordinate2D, 2000, 2000);
    MKCoordinateRegion adjustingRegion = [mapView regionThatFits:viewRegion];
    [mapView setRegion:adjustingRegion animated:YES];
    
    return mapView;
}

/**
 Fa uno zoom PERSONALIZZATO sulla mappa nel punto in cui ti trovi.
 */
+ (void)zoomMap:(MKMapView *)mapView withLatitudinalMeters:(double)latitudinalMeters andLongitudinalMeters:(double)longitudinalMeters {
    
    CLLocation *location = [LibLocation location];
    CLLocationCoordinate2D coordinate2D = [location coordinate];
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(coordinate2D, latitudinalMeters, longitudinalMeters);
    MKCoordinateRegion adjustingRegion = [mapView regionThatFits:viewRegion];
    [mapView setRegion:adjustingRegion animated:YES];
    
}
/**
 Fa uno zoom PERSONALIZZATO sulla mappa nel punto passato tramite location.
 */
+ (void)zoomMap:(MKMapView *)mapView withLocation:(CLLocation *)location withLatitudinalMeters:(double)latitudinalMeters andLongitudinalMeters:(double)longitudinalMeters{
    
    CLLocationCoordinate2D coordinate2D = [location coordinate];
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(coordinate2D, latitudinalMeters, longitudinalMeters);
    MKCoordinateRegion adjustingRegion = [mapView regionThatFits:viewRegion];
    [mapView setRegion:adjustingRegion animated:YES];
}

/**
 Mostra nella mappa i due punti A e B a qualunque distanza si trovino.
 */
+ (void)zoomMapMiddlePoint:(MKMapView *)mapView witLocationA:(CLLocation *)locationA withLocationB:(CLLocation *)locationB {
    double distance = [locationA distanceFromLocation:locationB];
    double latidude = (locationA.coordinate.latitude + locationB.coordinate.latitude) / 2;
    double longitude = (locationA.coordinate.longitude + locationB.coordinate.longitude) / 2;
    CLLocation *newLocation = [[CLLocation alloc] initWithLatitude:latidude longitude:longitude];
    [LibMap zoomMap:mapView withLocation:newLocation withLatitudinalMeters:distance andLongitudinalMeters:distance];
}

/**
 Mostra la mappa centrata sulla posione A
 */
+ (void)zoomMap:(MKMapView *)mapView centerIn:(CLLocation *)locationA andLocationB:(CLLocation *)locationB{
    double distance = [locationA distanceFromLocation:locationB];
    [LibMap zoomMap:mapView withLocation:locationA withLatitudinalMeters:distance andLongitudinalMeters:distance * 3];
}

@end
