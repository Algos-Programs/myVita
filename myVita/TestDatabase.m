 //
//  TestDatabase.m
//  myVita
//
//  Created by Marco Velluto on 06/05/13.
//  Copyright (c) 2013 Algos. All rights reserved.
//

#import "TestDatabase.h"
#import "Database.h"

@implementation TestDatabase

    NSMutableDictionary *dic;

- (void)setUp {
    
    dic = [[[NSMutableDictionary alloc] init] autorelease];
    [dic setValue:KEY_CATEGORIA forKey:KEY_CATEGORIA];
    [dic setValue:KEY_CODICE forKey:KEY_CODICE];
    [dic setValue:KEY_COMUNE forKey:KEY_COMUNE];
    [dic setValue:KEY_DISPONIBILITA forKey:KEY_DISPONIBILITA];
    [dic setValue:KEY_IMMAGINE forKey:KEY_IMMAGINE];
    [dic setValue:KEY_INDIRIZZO forKey:KEY_INDIRIZZO];
    [dic setValue:KEY_LATITUDINE forKey:[NSString stringWithFormat:@"%f",45.6326]];
    [dic setValue:KEY_LOCALITA forKey:KEY_LOCALITA];
    [dic setValue:KEY_LONGITUDINE forKey:[NSString stringWithFormat:@"%f",9.6326]];
    [dic setValue:KEY_MAIL forKey:KEY_MAIL];
    [dic setValue:KEY_NOME forKey:KEY_NOME];
    [dic setValue:KEY_OK forKey:KEY_OK];
    [dic setValue:KEY_SCAD_ELET forKey:KEY_SCAD_ELET];
    [dic setValue:KEY_SCAD_BATT forKey:KEY_SCAD_BATT];
    [dic setValue:KEY_STATO forKey:KEY_STATO];
    [dic setValue:KEY_TELEFONO forKey:KEY_TELEFONO];
    [dic setValue:KEY_TEL_PUNTO_BLU forKey:KEY_TEL_PUNTO_BLU];
    
}

- (void)testCreateTableDefibrillatori {
    Database *db = [[[Database alloc] init] autorelease];
    BOOL returnValue = [db createTableDefibrillatoi];
    NSAssert(returnValue, @"Table creata con successo");
}

- (void)testInsertRecord {
    Database *db = [[[Database alloc] init] autorelease];
    BOOL returnValue = [db insertRecord:dic];
    NSAssert(returnValue, @"Dictionary inserito con successo");
}

- (void)testCountOfDb {
   // STFail(@"Da implementare");
}

- (void)testObjects {
    Database *db = [[[Database alloc] init] autorelease];
    NSArray *returnValue = [db objects];
    NSAssert(returnValue.count != 0, @"Dont works");
    
    BOOL isEqual = [[[returnValue objectAtIndex:0] valueForKey:KEY_DISPONIBILITA] isEqual: @"H24"];
    NSAssert(isEqual, @"Descrizioni non coincidenti");
}

- (void)testObjectsV2 {
    Database *db = [[[Database alloc] init] autorelease];
    NSArray *returnValue = [db objectsV2];
    NSAssert(returnValue.count != 0, @"Dont works");
    
    BOOL isEqual = [[[returnValue objectAtIndex:0] allKeys] count] == 8;
    NSAssert(isEqual, @"Quantità di chiavi non uguale a 8");
}

- (void)testSortWithArray {
//TODO: Sto lavorando qui.
    NSMutableDictionary *dic1 = [[NSMutableDictionary alloc] init];
    [dic1 setValue:@"45.000" forKey:KEY_LATITUDINE];
    [dic1 setValue:@"40.000" forKey:KEY_LONGITUDINE];
    
    NSMutableDictionary *dic2 = [[NSMutableDictionary alloc] init];
    [dic1 setValue:@"45.000" forKey:KEY_LATITUDINE];
    [dic1 setValue:@"90.000" forKey:KEY_LONGITUDINE];

    NSMutableDictionary *dic3 = [[NSMutableDictionary alloc] init];
    [dic1 setValue:@"45.000" forKey:KEY_LATITUDINE];
    [dic1 setValue:@"50.000" forKey:KEY_LONGITUDINE];

    NSMutableArray *array = [[NSMutableArray alloc]init];
    [array addObject:dic1];
    [array addObject:dic2];
    [array addObject:dic3];
    NSArray *reuturnArray = [Database sortWithArray2:array];
    int k = 0;
}


@end
