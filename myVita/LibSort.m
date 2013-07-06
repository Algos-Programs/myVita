//
//  LibSort.m
//  myVita
//
//  Created by Marco Velluto on 01/07/13.
//  Copyright (c) 2013 Algos. All rights reserved.
//

#import "LibSort.h"
#import "LibLocation.h"
#import <CoreLocation/CoreLocation.h>
#import "Database.h"
#import "Dae.h"

@implementation LibSort

/**
    @param -> array di dictionay
 */
+ (NSArray *)ordinamentoArray:(NSArray *)array {
    
    NSArray *sortedArray = [array sortedArrayUsingComparator: ^(id obj1, id obj2) {
        
        Dae *dae1 = (Dae *)obj1;
        Dae *dae2 = (Dae *)obj2;

        
        if (dae1.latitudine < dae2.latitudine) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        
        if (dae1.latitudine > dae2.latitudine) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    return sortedArray;
}

+ (NSArray *)oridinamentoArrayV2:(NSMutableArray *)array {
    CLLocation *posizioneAttuale = [LibLocation location];

    NSArray *sortedArray = [array sortedArrayUsingComparator: ^(id obj1, id obj2) {
        
        NSDictionary *dic1 = (NSDictionary *)obj1;
        NSDictionary *dic2 = (NSDictionary *)obj2;
        
        //-- Calcolo obj 1
        double *lat1 = (double *)[dic1 objectForKey:KEY_LATITUDINE];
        double *lgn1 = (double *)[dic1 objectForKey:KEY_LONGITUDINE];
        CLLocation *loc1 = [[CLLocation alloc] initWithLatitude:*lat1 longitude:*lgn1];
        double dist1 = [loc1 distanceFromLocation:posizioneAttuale];
        
        //-- Calcolo obj 2
        double *lat2 = (double *)[dic2 objectForKey:KEY_LATITUDINE];
        double *lgn2 = (double *)[dic2 objectForKey:KEY_LONGITUDINE];
        CLLocation *loc2 = [[CLLocation alloc] initWithLatitude:*lat2 longitude:*lgn2];
        double dist2 = [loc2 distanceFromLocation:posizioneAttuale];

        
        if (dist1< dist2) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        
        if (dist1 > dist2) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    return sortedArray;
}

+ (NSArray *)oridinamentoArrayV3:(NSMutableArray *)array {
    CLLocation *posizioneAttuale = [LibLocation location];
    
    NSArray *sortedArray = [array sortedArrayUsingComparator: ^(id obj1, id obj2) {
        
        NSDictionary *dic1 = (NSDictionary *)obj1;
        NSDictionary *dic2 = (NSDictionary *)obj2;
        
        //-- Calcolo obj 1
        double lat1 = (double)[[dic1 objectForKey:KEY_LATITUDINE] doubleValue];
        double lgn1 = (double)[[dic1 objectForKey:KEY_LONGITUDINE] doubleValue];
        CLLocation *loc1 = [[CLLocation alloc] initWithLatitude:lat1 longitude:lgn1];
        double dist1 = [loc1 distanceFromLocation:posizioneAttuale];
        
        //-- Calcolo obj 2
        double lat2 = (double)[[dic2 objectForKey:KEY_LATITUDINE] doubleValue];
        double lgn2 = (double)[[dic2 objectForKey:KEY_LONGITUDINE] doubleValue];
        CLLocation *loc2 = [[CLLocation alloc] initWithLatitude:lat2 longitude:lgn2];
        double dist2 = [loc2 distanceFromLocation:posizioneAttuale];
        
        
        if (dist1< dist2) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        
        if (dist1 > dist2) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    return sortedArray;
}


@end
