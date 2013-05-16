//
//  TestFirstViewController.m
//  myVita
//
//  Created by Marco Velluto on 06/05/13.
//  Copyright (c) 2013 Algos. All rights reserved.
//

#import "TestFirstViewController.h"
#import "FirstViewController.h"

@implementation TestFirstViewController 

- (void)tessdtGetData {
    FirstViewController *fvc = [[[FirstViewController alloc] init] autorelease];
    [fvc getData];
}

@end
