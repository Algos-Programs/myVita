//
//  FirstViewController.m
//  myVita
//
//  Created by Marco Velluto on 26/03/13.
//  Copyright (c) 2013 Algos. All rights reserved.
//

#import "FirstViewController.h"
#import "LibLocation.h"
#import "LibMap.h"

@interface FirstViewController ()

@end

@implementation FirstViewController
@synthesize mapView;
@synthesize streetAdress;
@synthesize streetAdressSecondLine;
@synthesize city;
@synthesize state;
@synthesize ZIPCode;
@synthesize country;


- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.mapView.mapType = MKMapTypeStandard;
    
    //Request
    
    // Mostro all'utente la sua posizione sulla mappa.
    self.mapView.showsUserLocation = YES;
    CLLocation *location = [LibLocation findCurrentLocation];
    CLLocationCoordinate2D coordinate = [location coordinate];
    self.latitude = coordinate.latitude;
    self.longitude = coordinate.longitude;
}
- (void)viewWillAppear:(BOOL)animated {
    
    // Init Geocoder.
    gecoder = [[CLGeocoder alloc] init];

    [self localizedMe]; //init manager.
}

- (void)viewDidAppear:(BOOL)animated {
    
    [LibMap zoomMap:self.mapView withLatitudinalMeters:1000 andLongitudinalMeters:1000];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [self.mapView release];
    [self.streetAdress release];
    [self.streetAdressSecondLine release];
    [self.city release];
    [self.state release];
    [self.ZIPCode release];
    [self.country release];
    [super dealloc];
}

//************************************
#pragma mark - Localization Methods
//************************************


- (void)localizedMe {
    
    if (manager == nil)
        manager = [[CLLocationManager alloc] init];
    
    manager.delegate = self;
    manager.desiredAccuracy = kCLLocationAccuracyBest;
    [manager startUpdatingLocation];
}

@end
