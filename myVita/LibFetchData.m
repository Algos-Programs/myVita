//
//  LibFetchData.m
//  myVita
//
//  Created by Marco Velluto on 21/04/13.
//  Copyright (c) 2013 Algos. All rights reserved.
//

#import "LibFetchData.h"

@implementation LibFetchData

#define kBgQueue dispatch_get_global_queue (DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1
#define kLatestKivaLoansURL [NSURL URLWithString:@"http://77.43.32.198:8080/myvitaback/mappa"] //2


+ (NSArray *)fetchData {
    NSArray * array = [[NSArray alloc] init];
    
    dispatch_async(kBgQueue, ^{
        
        NSData* data = [NSData dataWithContentsOfURL:
                        kLatestKivaLoansURL];
        
        [self performSelectorOnMainThread:@selector(fetchedData:)
                               withObject:data waitUntilDone:YES];
         
    });
    return array;

}

+ (NSArray *)fetchedData:(NSData *)responseData {
    NSArray* json = [[NSArray alloc] init];
    if (responseData) {
        //parse out the json data
        NSError* error;
        //Array di Dictionary.
        json = [NSJSONSerialization
                         JSONObjectWithData:responseData //1
                         options:kNilOptions
                         error:&error];
        
        NSLog(@"DESCR_JSON: %@", [json description]); //3
        NSLog(@"COUNT_JSON: %lu", (unsigned long)[json count]); //3
        NSLog(@"COUNT_KEY_JSON: %i", [[[json objectAtIndex:0] allKeys] count]);
    }
    else
        NSLog(@"***ERROR: Response data is nill");
    return json;
}

@end
