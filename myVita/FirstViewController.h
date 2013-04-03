//
//  FirstViewController.h
//  myVita
//
//  Created by Marco Velluto on 26/03/13.
//  Copyright (c) 2013 Algos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface FirstViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate, MKAnnotation> {
    
    //-- Localizzazione
    CLGeocoder *gecoder;
    CLPlacemark *placemark;
    CLLocationManager *manager;

    //-- Info Location
    NSString *streetAdress;
    NSString *streetAdressSecondLine;
    NSString *city;
    NSString *subLocality;
    NSString *state;
    NSString *ZIPCode;
    NSString *country;
    
}

@property (retain, nonatomic) IBOutlet MKMapView *mapView;

//-- Info Location
@property (nonatomic, strong)NSString *streetAdress;
@property (nonatomic, strong)NSString *streetAdressSecondLine;
@property (nonatomic, strong)NSString *city;
@property (nonatomic, strong)NSString *state;
@property (nonatomic, strong)NSString *ZIPCode;
@property (nonatomic, strong)NSString *country;

@property (nonatomic, strong)NSArray *posizionrDef;

@property (nonatomic, strong)NSMutableArray *arr;

@property (nonatomic)double latitude;
@property (nonatomic)double longitude;

@end