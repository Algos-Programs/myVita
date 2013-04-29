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
#import "Database.h"
#import "Annotation.h"



@interface FirstViewController ()

@end

#define kBgQueue dispatch_get_global_queue (DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1
//#define kLatestKivaLoansURL [NSURL URLWithString:@"http://api.kivaws.org/v1/loans/search.json?status=fundraising"] //2
#define kLatestKivaLoansURL [NSURL URLWithString:@"http://77.43.32.198:8080/myvitaback/mappa"] //2

@implementation FirstViewController
@synthesize mapView;
@synthesize streetAdress;
@synthesize streetAdressSecondLine;
@synthesize city;
@synthesize state;
@synthesize ZIPCode;
@synthesize country;

static BOOL WITH_REFRESH = YES;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.mapType = MKMapTypeStandard;
    //[self.progressIndicatorView setHidesWhenStopped:YES];
    
    Database *db = [[Database alloc] init];
    if ([db allObjects].count == 0) {
        WITH_REFRESH = YES;
    }
    else {
        WITH_REFRESH = NO;
    }
    NSArray *locationArray = [db allLocation];
    NSArray *daeArray = [db allObjects];
   
#warning dont works NSArray *array2 = [db allObjectsInDictionary];
    NSArray *array2 = [db allObjectsInDictionary];
    [self.mapView setDelegate:self];
    int distanceMin = MAXFLOAT;
//    for (CLLocation *location in locationArray) {
//        Annotation *newAnnotation = [[Annotation alloc] init];
//        //int distance = [location distanceFromLocation:[LibLocation location]];
//        NSNumber *distance = [[[NSNumber alloc] initWithFloat:[[LibLocation location] distanceFromLocation:location]] autorelease];
//
//        //-- Indirizzo
//        NSString *str1 = [[daeArray objectAtIndex:8] objectAtIndex:7];
//        
//        //-- Disponibilità
//        NSString *str3 = [daeArray objectAtIndex:6];
//        
//        newAnnotation.title = [NSString stringWithFormat:@"%i metri", [distance intValue]];
//        newAnnotation.subtitle = [NSString stringWithFormat:@"%@ - %@", str1, str3];
//        newAnnotation.coordinate = location.coordinate;
//        
//
//        if ([distance intValue] < distanceMin) {
//            distanceMin = [distance intValue];
//            daePiuVicino = location;
//        }
//        [self.mapView addAnnotation:newAnnotation];
//    }
    
    for (int i=0; i<locationArray.count; i++) {
        
        CLLocation *location = [[locationArray objectAtIndex:i] autorelease];
        Annotation *newAnnotation = [[Annotation alloc] init];
        NSNumber *distance = [[[NSNumber alloc] initWithFloat:[[LibLocation location] distanceFromLocation:location]] autorelease];
        NSString *indirizzo = [[daeArray objectAtIndex:i] objectAtIndex:7];
        NSString *disponibilita = [[daeArray objectAtIndex:i] objectAtIndex:5];
        newAnnotation.title = [NSString stringWithFormat:@"%i metri", [distance intValue]];
        newAnnotation.subtitle = [NSString stringWithFormat:@"%@ - %@", disponibilita, indirizzo];
        newAnnotation.coordinate = location.coordinate;
        if ([distance intValue] < distanceMin) {
            distanceMin = [distance intValue];
            daePiuVicino = location;
        }
        [self.mapView addAnnotation:newAnnotation];

    }
    
    self.distanceLabel.text = [NSString stringWithFormat:@"%i metri", distanceMin];

    // Mostro all'utente la sua posizione sulla mappa.
    self.mapView.showsUserLocation = YES;
    
    if (WITH_REFRESH) {
        dispatch_async(kBgQueue, ^{
            
            NSData* data = [NSData dataWithContentsOfURL:
                            kLatestKivaLoansURL];
            [self performSelectorOnMainThread:@selector(fetchedData:)
                                   withObject:data waitUntilDone:YES];
        });
    }
    else
        [self.loadImage setHidden:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.progressIndicatorView startAnimating];

    // Init Geocoder.
    gecoder = [[CLGeocoder alloc] init];
    
    [self localizedMe]; //init manager.

}

- (void)viewDidAppear:(BOOL)animated {
    
    [self zoom];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"****ERROR: MEMORY WARING");
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
    [_progressIndicatorView release];
    [_progressBar release];
    [_distanceLabel release];
    [_loadImage release];
    [super dealloc];
}

//************************************
#pragma mark - Fetch Data Methods
//************************************

- (void)fetchedData:(NSData *)responseData {
    
    if (responseData) {
        //parse out the json data
        NSError* error;
        
        //Array di Dictionary.
        NSArray* json = [NSJSONSerialization
                         JSONObjectWithData:responseData //1
                         options:kNilOptions
                         error:&error];
        
        NSLog(@"DESCR_JSON: %@", [json description]); //3
        NSLog(@"COUNT_JSON: %lu", (unsigned long)[json count]); //3
        NSLog(@"COUNT_KEY_JSON: %i", [[[json objectAtIndex:0] allKeys] count]);
        
        Database *db = [[Database alloc] init];
        [db openDB];
        [db DeleteTable:@"Defibrillatore"];
        [db createTableDefibrillatore];
        
        NSLog(@"-.- Inzio Carico Dati -.-");
        
        CGFloat progressBarCount = 1.0000 / json.count;
        
        int c =0;
        for (int i=0; i<json.count; i++) {
            [self.progressBar setProgress:progressBarCount * i];
            
            if (![db insertRecordWithDefibrillatore:[json objectAtIndex:i]]) {
                NSLog(@"--- i = %i", i);
                c++;
            }
        }
        //[db popolaTabellaWithArray:json];
        
        NSLog(@"-.- Fine Carico Dati -.-");
        //NSLog(@"c = %i", c);
        
    }
    
    [self.progressIndicatorView stopAnimating];
    [self.progressIndicatorView setHidesWhenStopped:YES];
    self.loadImage.hidden = YES;
}

//************************************
#pragma mark - Localization Methods
//************************************

- (void)zoom {
    
    [LibMap zoomMap:self.mapView withLatitudinalMeters:800 andLongitudinalMeters:800];
    [self.progressIndicatorView stopAnimating];
}

- (void)localizedMe {
    
    if (manager == nil)
        manager = [[CLLocationManager alloc] init];
    
    manager.delegate = self;
    manager.desiredAccuracy = kCLLocationAccuracyBest;
    [manager startUpdatingLocation];
    [self.progressIndicatorView stopAnimating];

}

//************************************
#pragma mark - Map Methods
//************************************

- (MKAnnotationView *) mapView:(MKMapView *)aMapView viewForAnnotation:(id <MKAnnotation>) annotation{
    MKPinAnnotationView *pinAnnotation = nil;
    if(annotation != mapView.userLocation)
    {
        MKPinAnnotationView *pinAnnotation = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"sadasdasd"];
        if ( pinAnnotation == nil ){
            pinAnnotation = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"sadasdasd"] autorelease];
            
            /* add detail button */
            NSLog(@"Here");
            
            UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            pinAnnotation.rightCalloutAccessoryView = infoButton;
            
            
        }
        
    }
    
    return pinAnnotation;
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay {
    //-- Posizione Attuale.
    CLLocation *location = [LibLocation location];
    CLLocationCoordinate2D coordinate = [location coordinate];
    
    
    CLLocationCoordinate2D coord[2];
    coord[0].latitude = 45.421961;
    coord[0].longitude = 9.123177;
    coord[1].latitude = coordinate.latitude; //P.A.
    coord[1].longitude = coordinate.longitude; //P.A.
    
    MKPolyline *polyline = [[MKPolyline alloc] init];
    polyline = [MKPolyline polylineWithCoordinates:coord count:3];
    
    MKPolylineView *polyLineView = [[MKPolylineView alloc] initWithPolyline:polyline];
    polyLineView.fillColor = [UIColor blueColor];
    polyLineView.strokeColor = [UIColor blueColor];
    polyLineView.lineWidth = 7;
    return polyLineView;
    
    
}

-(void)drawPolylineWithALocation:(CLLocation *)aLocation withBLocation:(CLLocation *)bLocation {
    
    /*
    CLLocationCoordinate2D firstCoords = [aLocation coordinate];
    
    CLLocationCoordinate2D secondCoords = [bLocation coordinate];    
    
    CLLocationCoordinate2D routeCoordinates [2];
    routeCoordinates[0] = CLLocationCoordinate2DMake(firstCoords.latitude, firstCoords.longitude);
    routeCoordinates[1] = CLLocationCoordinate2DMake(secondCoords.latitude, secondCoords.longitude);
    MKPolyline *routeLine = [MKPolyline polylineWithCoordinates:routeCoordinates count:2];
    
    
    [self.mapView addOverlay:routeLine];
     */
     
     CLLocationCoordinate2D firstCoords;
     firstCoords.latitude = 45.921084;
     firstCoords.longitude = 9.519747;
     
     CLLocationCoordinate2D secondCoords;
     secondCoords.latitude = 45.421084;
     secondCoords.longitude = 9.119747;
     
     
     CLLocationCoordinate2D routeCoordinates [2];
     routeCoordinates[0] = CLLocationCoordinate2DMake(firstCoords.latitude, firstCoords.longitude);
     routeCoordinates[1] = CLLocationCoordinate2DMake(secondCoords.latitude, secondCoords.longitude);
     MKPolyline *routeLine = [MKPolyline polylineWithCoordinates:routeCoordinates count:2];
     [self.mapView addOverlay:routeLine];



}

//************************************
#pragma mark - Action Methods
//************************************

- (IBAction)pressButtonZoom:(id)sender {
    [self zoom];
}

- (IBAction)pressButtonZoomDAE:(id)sender {
    [LibMap zoomMap:self.mapView withLocation:daePiuVicino withLatitudinalMeters:2000 andLongitudinalMeters:2000];
}

- (IBAction)pressButtonSeeDaeAndActualPosition:(id)sender {
    [LibMap zoomMapMiddlePoint:self.mapView witLocationA:daePiuVicino withLocationB:[LibLocation location]];
}
@end
