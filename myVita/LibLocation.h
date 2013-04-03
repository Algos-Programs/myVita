//
//  LibLocation.h
//  myVita
//
//  Created by Marco Velluto on 26/03/13.
//  Copyright (c) 2013 Algos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LibLocation : NSObject

/**
 Restituisce la localizzazione attuale.
 */
+ (CLLocation*)findCurrentLocation;
+ (CLLocation*)location;

/**
 Calcola la distanza tra la posizione attuale e la posizione passata
 */
+ (float)calcoloDistanza:(CLLocation *)location;

/**
 Calcola la distanza tra la posizione A e la posizione B
 */
+ (float)calcoloDistanzaWithALocation:(CLLocation *)aLocation andBLocation:(CLLocation *)bLocation;
    

@end
