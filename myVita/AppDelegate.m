//
//  AppDelegate.m
//  myVita
//
//  Created by Marco Velluto on 26/03/13.
//  Copyright (c) 2013 Algos. All rights reserved.
//

#import "AppDelegate.h"
#import "Database.h"

@implementation AppDelegate

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    /*
    Database *db = [[Database alloc] init];
    [db openDB];
    [db createTableNamedDefibrillatori];
    
        MDefibrillatore *def = [[MDefibrillatore alloc] initWithCap:20090
                                                           withProv:@"Milano"
                                                         withComune:@"Buccinasco"
                                                       withFrazione:@""
                                                      withIndirizzo:@"Via Marzabotto 10"
                                                           withNome:@"Palazzo"
                                                         withOrario:@"H24"
                                                        withAccesso:@"Privato"
                                                    withRiferimento:@"Marco"
                                                            withTel:@"346 0602722"
                                                     withLatitudine:45.421261
                                                    withLongitudine:9.123877
                                                              andOK:true];
        [db insertRecordWithDefibrillatore:def];
*/
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end