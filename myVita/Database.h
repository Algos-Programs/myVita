//
//  Database.h
//  myVita
//
//  Created by Marco Velluto on 26/03/13.
//  Copyright (c) 2013 Algos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"

@interface Database : NSObject {
    
    sqlite3 *db;
}

- (void) openDB;
- (void)createTableNamedDefibrillatori;
- (void)createTableNamedDefibrillatore;
- (void)insertRecordWithDefibrillatore:(NSArray *)arrDefibrillatore;
- (NSArray *)allObjects;

@end
