//
//  TestLibUtil.m
//  myVita
//
//  Created by Marco Velluto on 27/06/13.
//  Copyright (c) 2013 Algos. All rights reserved.
//

#import "TestLibUtil.h"
#import "LibUtil.h"

@implementation TestLibUtil

- (void)testIsTrue {
    
    NSAssert([LibUtil isTRUE:@"si"], @"1 - si non riconosciuto");
    NSAssert([LibUtil isTRUE:@"sI"], @"2 - sI non riconosciuto");
    NSAssert([LibUtil isTRUE:@"Si"], @"3 - Si non riconosciuto");
    NSAssert([LibUtil isTRUE:@"SI"], @"4 - SI non riconosciuto");

    NSAssert(![LibUtil isTRUE:@"none"], @"5 - none riconosciuto");
    NSAssert(![LibUtil isTRUE:@"siii"], @"6 - siii riconosciuto");
    NSAssert(![LibUtil isTRUE:@"NO"], @"7 - NO riconociuto");
}

- (void)testIsOk {
    
    NSAssert([LibUtil isOK:@"ok"], @"1 - ok non riconosciuto");
    NSAssert([LibUtil isOK:@"Ok"], @"2 - Ok non riconosciuto");
    NSAssert([LibUtil isOK:@"oK"], @"3 - oK non riconosciuto");
    NSAssert([LibUtil isOK:@"OK"], @"4 - OK non riconosciuto");
    
    NSAssert(![LibUtil isOK:@"si"], @"5 - si riconosciuto");
    NSAssert(![LibUtil isOK:@"okk"], @"6 - okk riconociuto");

    
}
@end
