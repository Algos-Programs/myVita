//
//  myVitaTests.m
//  myVitaTests
//
//  Created by Marco Velluto on 26/03/13.
//  Copyright (c) 2013 Algos. All rights reserved.
//

#import "myVitaTests.h"
#import <CoreLocation/CoreLocation.h>

@implementation myVitaTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testExample
{
    //STFail(@"Unit tests are not implemented yet in myVitaTests");
}

- (void)testSort {
    NSMutableArray * array = [[NSMutableArray alloc] initWithObjects:@"1", @"23", @"444", @"5", nil];
    for (int i=0; i<1000; i++) {
        [array addObject:[NSString stringWithFormat:@"%i", rand()]];
    }
    [self sortWithArray:array];
}


- (int)maxInArray:(NSArray *)array withI:(int)i withZ:(int)z {
    
    if (i==z) {
        return i;
    }
    if (z == i+1) {
        if ([[array objectAtIndex:i] integerValue] > [[array objectAtIndex:i+1] integerValue])
            return i;
        else
            return i+1;
    }
    else {
        int m = (i + z) / 2;
        int sx = [self maxInArray:array withI:i withZ:m];
        int dx = [self maxInArray:array withI:m+1 withZ:z];
        
        if ([array objectAtIndex:dx] > [array objectAtIndex:sx])
            return dx;
        
        else
            return sx;
    }
}

- (NSArray *)sortWithArray:(NSMutableArray *)mArray {
    
    NSMutableArray *returnArray = [[[NSMutableArray alloc] init] autorelease];
    NSMutableArray *tempArray = [[[NSMutableArray alloc] initWithArray:mArray.copy] autorelease];
    
    NSLog(@"INIZIO + sortWithArray Test");
    while (tempArray.count != 0) {
        int index = [self minInArray:tempArray withI:0 withZ:tempArray.count - 1];
        [returnArray addObject:[tempArray objectAtIndex:index]];
        [tempArray removeObjectAtIndex:index];
    }
    NSLog(@"FINE");
    
    return returnArray;
}

- (int)minInArray:(NSArray *)array withI:(int)i withZ:(int)z {
    
    if (i==z) {
        return i;
    }
    if (z == i+1) {
        if ([[array objectAtIndex:i] integerValue] < [[array objectAtIndex:i+1] integerValue]){
            return i;
        }
        else {
            return i+1;
        }
    }
    else {
        int m = (i + z) / 2;
        int sx = [self minInArray:array withI:i withZ:m];
        int dx = [self minInArray:array withI:m+1 withZ:z];
        
        if ([[array objectAtIndex:dx] integerValue] < [[array objectAtIndex:sx] integerValue])
            return dx;
        
        else
            return sx;
    }
}


@end
