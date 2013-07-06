//
//  TestLibSort.m
//  myVita
//
//  Created by Marco Velluto on 01/07/13.
//  Copyright (c) 2013 Algos. All rights reserved.
//

#import "TestLibSort.h"
#import "LibSort.h"
#import "Dae.h"

@implementation TestLibSort

NSMutableArray *array;

- (void)setUp {
    
    Dae *a = [[Dae alloc] init];
    a.latitudine = 76;
    
    Dae *b = [[Dae alloc] init];
    b.latitudine = 4;
    
    Dae *c = [[Dae alloc] init];
    c.latitudine = 55;
    
    Dae *d = [[Dae alloc] init];
    d.latitudine = 1;
    
    array = [[NSMutableArray alloc] init];
    [array addObject:a];
    [array addObject:b];
    [array addObject:c];
    [array addObject:d];


}

- (void)testOrdinaArray {
    [LibSort ordinamentoArray:array];
}

@end
