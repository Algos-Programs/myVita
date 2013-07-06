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
#import "LibUtil.h"
#import "Costanti.h"



@interface FirstViewController ()

@end



#define kBgQueue dispatch_get_global_queue (DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1
#define kLatestKivaLoansURL [NSURL URLWithString:@"http://77.43.32.198:8080/myvitaback/mappa"] //2
#define kDatiDefinitivi [NSURL URLWithString:@"http://77.43.32.198:8080/myvitaback/mappa/datidefinitivi"] //2

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
    [self getBool];
    [self.mapView setDelegate:self];
    self.mapView.mapType = MKMapTypeStandard;
    
    
    Database *db = [[Database alloc] init];
    NSArray *daeArray = [db objects];
    if (daeArray.count == 0) {
        WITH_REFRESH = YES;
        [self getData];
    }
    else {
        WITH_REFRESH = NO;
        [self loadDae];
        [self.loadImage setHidden:YES];
    }
    
    
    // Mostro all'utente la sua posizione sulla mappa.
    self.mapView.showsUserLocation = YES;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [self loadDae];
    // Init Geocoder.
    gecoder = [[CLGeocoder alloc] init];
    
    [LibLocation location];
    //[self localizedMe]; //init manager.
}

- (void)viewDidAppear:(BOOL)animated {
    
    [self pressButtonSeeDaeAndActualPosition:nil];
    //[LibMap zoomMap:self.mapView withLatitudinalMeters:300 andLongitudinalMeters:300];
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
#pragma mark - Carico Dati
//************************************

/**
 Prepara il metodo loadDae:deaAray
 */
- (void)loadDae { //OK
    Database *db = [[Database alloc] init];
    NSArray *daeArray = [db objectsV3];
    [self loadDaeWithDaeArray:daeArray];
}

/**
 Inserisce i DAE nella mappa.
 SOLO I DAE CON LE LE LOCALIZZAZIONI VERRANNO INSERITE NELLA MAPPA.
 @param db -> Database da cui prendere tutti i dati con le relative localizzazioni.
 @param daeArray -> array contentente tutti i dati presenti del database.
 @deprecated
 */
//TODO: Carico Dae sulla mappa.
- (void)loadDae:(Database *)db daeArray:(NSArray *)daeArray {
    int distanceMin = MAXFLOAT;
    NSArray *locationArray = [db allLocation];
    
    for (int i=0; i<locationArray.count; i++) {
        CLLocation *location = [[locationArray objectAtIndex:i] autorelease];
        Annotation *newAnnotation = [[Annotation alloc] init];
        NSNumber *distance = [[[NSNumber alloc] initWithFloat:[[LibLocation location] distanceFromLocation:location]] autorelease];
        NSString *indirizzo = [[daeArray objectAtIndex:i] valueForKey:KEY_INDIRIZZO];
        NSString *disponibilita = [[daeArray objectAtIndex:i] valueForKey:KEY_DISPONIBILITA];
        newAnnotation.title = [NSString stringWithFormat:@"%i metri", [distance intValue]];
        newAnnotation.subtitle = [NSString stringWithFormat:@"%@ - %@", disponibilita, indirizzo];
        newAnnotation.coordinate = location.coordinate;
        if ([distance intValue] < distanceMin) {
            distanceMin = [distance intValue];
            daePiuVicino = location;
        }
        [self.mapView addAnnotation:newAnnotation];
        
    }
    if (distanceMin > 100000 || distanceMin < 0) {
        [self.distanceLabel setFont:[UIFont systemFontOfSize:10]];
        self.distanceLabel.text = @"Distanza non disponibile";
    }
    else
        self.distanceLabel.text = [NSString stringWithFormat:@"%i metri", distanceMin];
}

/**
 Inserisce nella mappa i DAE contenuti nell'array passato come parametro.
 */
//TODO: Carico Dae sulla mappa.
- (void)loadDaeWithDaeArray:(NSArray *)daeArray {
    int distanceMin = MAXFLOAT;
    for (NSDictionary *dic in daeArray) {
        double latituidine = (double)[[dic objectForKey:KEY_LATITUDINE] doubleValue];
        double longituidine = (double)[[dic objectForKey:KEY_LONGITUDINE] doubleValue];
        CLLocation *location = [[CLLocation alloc] initWithLatitude:latituidine longitude:longituidine];
        Annotation *newAnnotation = [[Annotation alloc] init];
        NSNumber *distance = [[[NSNumber alloc] initWithFloat:[[LibLocation location] distanceFromLocation:location]] autorelease];
        NSString *indirizzo = [dic valueForKey:KEY_INDIRIZZO];
        NSString *disponibilita = [dic valueForKey:KEY_DISPONIBILITA];
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

}


//** Prendo il BOOL dati definitivi

/**
 Prende la risposta dal server
 SI -> se i dati sono quelli definitivi,
 di conseguenza visualizzerò soltanto quelli con il flag ok settato su YES.
 */
- (void)getBool {
    dispatch_sync(kBgQueue, ^{
        
        NSData* data = [NSData dataWithContentsOfURL:
                        kDatiDefinitivi];
        [self performSelectorOnMainThread:@selector(fetchedBool:)
                               withObject:data waitUntilDone:YES];
    });
}
- (void)fetchedBool:(NSData *)responseData {
    
    if (responseData) {
        //parse out the json data
        NSError* error;
        
        //Array di Dictionary.
        NSArray* json = [NSJSONSerialization
                         JSONObjectWithData:responseData //1
                         options:kNilOptions
                         error:&error];
        
        
        NSLog(@"DESCR_JSON: %@", [json description]); //3
        
        self.datiDefinitivi = [LibUtil isTRUE:[json description]];
    }
    
    else {
        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"Errore" message:@"Fallita connessione al server \nImpossible scaricare risposta" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alerView setTag:1];
        [alerView show];
    }
}

//** Prendo tutti i dati del JSON
/**
 Prendo i dati del json.
 */
- (void)getData {
    dispatch_sync(kBgQueue, ^{
        
        NSData* data = [NSData dataWithContentsOfURL:
                        kLatestKivaLoansURL];
        [self performSelectorOnMainThread:@selector(fetchedData:)
                               withObject:data waitUntilDone:YES];
    });
}
- (void)inseriscoDati:(int)c i:(int)i json:(NSArray *)json db:(Database *)db {
    if (![db insertRecord:[json objectAtIndex:i]]) {
        
        
        NSLog(@"--- i = %i", i);
        c++;
    }
}

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
        
        [db DeleteTable:@"Defibrillatori"];
        [db createTableDefibrillatori];
        
        NSLog(@"-.- Inzio Carico Dati -.-");
        
        CGFloat progressBarCount = 1.0000 / json.count;
        
        int c =0;
        for (int i=0; i<json.count; i++) {
            [self.progressBar setProgress:progressBarCount * i];
            
            //TODO: Flag dati definitivi
            if (/*self.datiDefinitivi*/false) { //Controllo il flag "dati definitivi"
                NSDictionary *tempDic = [[[NSDictionary alloc] init] autorelease];
                tempDic = [json objectAtIndex:i];
                
                if ([LibUtil isOK:[tempDic objectForKey:KEY_OK]]) { //inserisco solo quel col flag ok definitivo
                    [self inseriscoDati:c i:i json:json db:db];
                }
            }
            else //inserisco tutti i dati nel db
                [self inseriscoDati:c i:i json:json db:db];
            
        }
        
        NSLog(@"-.- Fine Carico Dati -.-");
        //NSLog(@"c = %i", c);
        
        [self.progressIndicatorView stopAnimating];
        [self.progressIndicatorView setHidesWhenStopped:YES];
        [self.view reloadInputViews];
        [self pressButtonSeeDaeAndActualPosition:nil];
        self.loadImage.hidden = YES;
        
        
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Aggiornamento" message:@"La lista è gia aggiornata" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView setTag:DATI_AGGIORNATI_SUCCESSFULL];
        [alertView show];
         
    }
    
    else {
        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"Errore" message:@"Fallita connessione al server \nImpossibile scaricare le posizion dei DAE" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alerView setTag: DATI_AGGIORNATI_ERROR];
        [alerView show];
        self.loadImage.hidden = YES;
    }
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

/**
 Effettua
 */
- (IBAction)pressButtonSeeDaeAndActualPosition:(id)sender {
    //[LibMap zoomMapMiddlePoint:self.mapView witLocationA:daePiuVicino withLocationB:[LibLocation location]];
    if (daePiuVicino != nil)
        [LibMap zoomMap:self.mapView centerIn:[LibLocation location] andLocationB:daePiuVicino];
    else {
        [self loadDae];
        [self.view reloadInputViews];
    }
}

- (IBAction)pressButtonsItemBar:(id)sender {
    UIBarButtonItem *barButtonItem = (UIBarButtonItem *)sender;
    [LibMap zoomMap:self.mapView withLatitudinalMeters:barButtonItem.tag + 100 andLongitudinalMeters:barButtonItem.tag + 100];
}

//************************************
#pragma mark - Alert view delegate
//************************************

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    int k = 0;
    switch (alertView.tag) {
        case DATI_AGGIORNATI_SUCCESSFULL:
            
            [self viewWillAppear:NO];
            
            //[LibMap zoomMap:self.mapView];
            [self pressButtonSeeDaeAndActualPosition:nil];
            break;
            
        default:
            break;
    }
}

@end
