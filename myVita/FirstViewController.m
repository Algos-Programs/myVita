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




- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.mapView.mapType = MKMapTypeStandard;
    
    
    [self.mapView setDelegate:self];
    //Request
    
    // Mostro all'utente la sua posizione sulla mappa.
    self.mapView.showsUserLocation = YES;
    
    Database *db = [[Database alloc] init];
    [db openDB];
    [db createTableNamedDefibrillatore];
    
    dispatch_async(kBgQueue, ^{
        
        NSData* data = [NSData dataWithContentsOfURL:
                        kLatestKivaLoansURL];
        [self performSelectorOnMainThread:@selector(fetchedData:)
                               withObject:data waitUntilDone:YES];
    });
    
    
    
}

- (void)fetchedData:(NSData *)responseData {
    //parse out the json data
    NSError* error;
    NSArray* json = [NSJSONSerialization
                          JSONObjectWithData:responseData //1
                          
                          options:kNilOptions
                          error:&error];
    
    //NSArray* latestLoans = [json objectForKey:@"loans"]; //2
    
    NSDictionary *dic = [json objectAtIndex:0];
    NSLog(@"nome: %@", [dic objectForKey:@"nome"]); //3
}

- (void)viewWillAppear:(BOOL)animated {
    
    // Init Geocoder.
    gecoder = [[CLGeocoder alloc] init];
    
    [self localizedMe]; //init manager.
    
    Annotation *myAnnotation = [Annotation alloc];
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    [arr addObject:@"Scarica"]; //stato-batteria
    [arr addObject:@"bho"]; //cartelli
    [arr addObject:@"B"]; //categoria
    [arr addObject:@"vicino alla fontana"]; //collocazione
    [arr addObject:@"crescenza"]; //comune
    [arr addObject:@"12"]; //corso
    [arr addObject:@"H24"]; //disponibilita
    [arr addObject:@"scaduti"]; //scadenza elettrodi
    [arr addObject:@"via pippoz 99"]; //indirizzo
    [arr addObject:@"99.4536123"]; //*-*latitudine
    [arr addObject:@"Nel deserto del sahara"]; //posizione
    [arr addObject:@"9.9837482"]; //*-* longitudine
    [arr addObject:@"velluto88.gml.com"]; //mail
    [arr addObject:@"che ne so"]; //modello
    [arr addObject:@"Marco"]; //nome
    [arr addObject:@"nessuna"]; //note
    [arr addObject:@"YES"]; //+_+ ok
    [arr addObject:@"Roma"]; //provincia
    [arr addObject:@"BHO"]; //riferimento
    [arr addObject:@"o.O"]; //serie
    [arr addObject:@"Italia"]; //stato
    [arr addObject:@"Vetro"]; //teca
    [arr addObject:@"345-998462"]; //telefono
    [arr addObject:@"999-987-321"]; //telefono-punto-blu
    [arr addObject:@"NO"]; //verifica
    
    Database *db = [[Database alloc] init];
    [db openDB];
    [db createTableNamedDefibrillatore];
    [db insertRecordWithDefibrillatore:arr];

    
    for (int i=0; i<self.posizionrDef.count; i++) {
        
/*
        MDefibrillatore *defibrillatore = [[MDefibrillatore alloc] init];
        defibrillatore = [self.posizionrDef objectAtIndex:i];
        
        CLLocationCoordinate2D coordiante;
        coordiante.latitude = defibrillatore.latitudine;
        coordiante.longitude = defibrillatore.longitudine;
        
        myAnnotation = [[Annotation alloc] init];
        myAnnotation.coordinate = coordiante;
        myAnnotation.title = defibrillatore.nome;
        myAnnotation.subtitle = defibrillatore.indirizzo;
        
        MKAnnotationView *customPinView = [[MKAnnotationView alloc] initWithAnnotation:myAnnotation reuseIdentifier:nil];
        customPinView.image = [UIImage imageNamed:@"pin1.png"];

        //[self mapView:self.mapView viewForAnnotation:myAnnotation];
        [self.mapView addAnnotation:myAnnotation
         ];
 */
    }
}


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
- (void)viewDidAppear:(BOOL)animated {
    
    [LibMap zoomMap:self.mapView withLatitudinalMeters:800 andLongitudinalMeters:800];

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

//************************************
#pragma mark - Map Methods
//************************************

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

@end
