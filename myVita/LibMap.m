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
    
    CLLocation *location = [LibLocation findCurrentLocation];
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
    
    CLLocation *location = [LibLocation findCurrentLocation];
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


@end
