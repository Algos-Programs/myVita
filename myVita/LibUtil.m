//
//  LibUtil.m
//  myVita
//
//  Created by Marco Velluto on 27/06/13.
//  Copyright (c) 2013 Algos. All rights reserved.
//

#import "LibUtil.h"

@implementation LibUtil

/**
 Controlla se la stringa passata contiene si oppure yes non tenendo conto del case sensitive.
 @return YES -> se la stringa passata contiene SI oppure YES.
 */
+ (BOOL)isTRUE:(NSString *)str {

     str = [str uppercaseString];
    NSRange range = [str rangeOfString:@"SI" options:NSCaseInsensitiveSearch];
    
    if (range.location != NSNotFound) {
        return YES;
    }
    else
        return NO;    
}

+ (BOOL)isOK:(NSString *)str {
    str = [str uppercaseString];
    NSRange range = [str rangeOfString:@"OK" options:NSCaseInsensitiveSearch];
    if (range.location != NSNotFound) {
        return YES;
    }
    else
        return NO;
    
    if ([str isEqualToString:@"OK"])
        return YES;
    
    else
        return NO;

}
@end
