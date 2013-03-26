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


@end
