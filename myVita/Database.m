
//
//  Database.m
//  myVita
//
//  Created by Marco Velluto on 26/03/13.
//  Copyright (c) 2013 Algos. All rights reserved.
//

#import "Database.h"
#import "LibLocation.h"
#import <CoreLocation/CoreLocation.h>

@implementation Database

static NSString * const TABLE_NAME_DEFIBRILLATORI = @"Defibrillatori";
static NSString * const TABLE_NAME_DEFIBRILLATORE = @"Defibrillatore"; __attribute__ ((deprecated))

static NSString * const DATABASE_NAME = @"database.sql";

- (NSString *) filePath {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    
    return [documentsDir stringByAppendingPathComponent:@"DatabaseTest.sql"];
}

- (void) openDB {
    
    //-- Create Database --
    if (sqlite3_open([[self filePath] UTF8String], &(db)) != SQLITE_OK) {
        
        sqlite3_close(db);
        NSLog(@"**** ERROR: Fallita apertura DB");
    }
}

//************************************
#pragma mark - Creazione Tabelle
//************************************


- (BOOL)createTableDefibrillatori {
    char *err;
    NSString *query = [[[NSString alloc] initWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' "
                        "INTEGER PRIMARY KEY, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' REAL, '%@' TEXT, '%@' REAL, '%@' TEXT, '%@' TEXT, '%@' INTEGER, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT);",
                        TABLE_NAME_DEFIBRILLATORI,
                        @"id",
                        KEY_CATEGORIA, //1...
                        KEY_CODICE,
                        KEY_COMUNE,
                        KEY_DISPONIBILITA,
                        KEY_IMMAGINE,
                        KEY_INDIRIZZO,
                        KEY_LATITUDINE, //..7..
                        KEY_LOCALITA,
                        KEY_LONGITUDINE, //..9..
                        KEY_MAIL,
                        KEY_NOME,
                        KEY_OK, //..12..
                        KEY_SCAD_BATT,
                        KEY_SCAD_ELET,
                        KEY_STATO,
                        KEY_TELEFONO,
                        KEY_TEL_PUNTO_BLU,
                        KEY_LAST_UPDATE] autorelease]; //18.
    [self openDB];
    if (sqlite3_exec(db, [query UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        sqlite3_close(db);
        NSLog(@"*****ERRORE:Table %@ falied create. - %s", TABLE_NAME_DEFIBRILLATORI, err);
        return false;
    }
    return true;
}

//************************************
#pragma mark - Inseriemento Oggetti
//************************************


- (BOOL)insertRecord:(NSDictionary *)dicDefibrillatori {
    //I record del DB parono da 1.
    
    int countDB = [self countOfDbFromTableNamed:TABLE_NAME_DEFIBRILLATORI] + 1;
    int ultimaModifica = 0;
    
    //-- Controllo
    if ([dicDefibrillatori objectForKey:KEY_ULTIMA_MODIFICA] == NULL) {
        ultimaModifica = 0;
    }
    else
        ultimaModifica = (int)[dicDefibrillatori objectForKey:KEY_ULTIMA_MODIFICA];
    
    NSString *str = [dicDefibrillatori objectForKey:KEY_STATO];
    str = [str stringByReplacingOccurrencesOfString:@"'" withString:@""];
    
    //19
    NSString *query = [[NSString alloc] initWithFormat:@"INSERT OR REPLACE INTO '%@' ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')"
                       "VALUES ('%d','%@','%@','%@','%@','%@','%@','%f','%@','%f','%@','%@','%@','%@','%@','%@','%@','%@','%@')",
                        TABLE_NAME_DEFIBRILLATORI,
                        @"id",
                        KEY_CATEGORIA,
                        KEY_CODICE,
                        KEY_COMUNE,
                        KEY_DISPONIBILITA,
                        KEY_IMMAGINE,
                        KEY_INDIRIZZO,
                        KEY_LATITUDINE,
                        KEY_LOCALITA,
                        KEY_LONGITUDINE,
                        KEY_MAIL,
                        KEY_NOME,
                        KEY_OK,
                        KEY_SCAD_BATT,
                        KEY_SCAD_ELET,
                        KEY_STATO,
                        KEY_TELEFONO,
                        KEY_TEL_PUNTO_BLU,
                        KEY_LAST_UPDATE,
                        
                        countDB,
                       [dicDefibrillatori objectForKey:KEY_CATEGORIA],
                       [dicDefibrillatori objectForKey:KEY_CODICE],
                       [dicDefibrillatori objectForKey:KEY_COMUNE],
                       [dicDefibrillatori objectForKey:KEY_DISPONIBILITA],
                       [dicDefibrillatori objectForKey:KEY_IMMAGINE],
                       [dicDefibrillatori objectForKey:KEY_INDIRIZZO],
                       [[dicDefibrillatori objectForKey:KEY_LATITUDINE] doubleValue],
                       [dicDefibrillatori objectForKey:KEY_LOCALITA],
                       [[dicDefibrillatori objectForKey:KEY_LONGITUDINE] doubleValue],
                       [dicDefibrillatori objectForKey:KEY_MAIL],
                       [dicDefibrillatori objectForKey:KEY_NOME],
                       [dicDefibrillatori objectForKey:KEY_OK],
                       [dicDefibrillatori objectForKey:KEY_SCAD_BATT],
                       [dicDefibrillatori objectForKey:KEY_SCAD_ELET],
                       [dicDefibrillatori objectForKey:KEY_STATO],
                       [dicDefibrillatori objectForKey:KEY_TELEFONO],
                       [dicDefibrillatori objectForKey:KEY_TEL_PUNTO_BLU],
                       [dicDefibrillatori objectForKey:KEY_LAST_UPDATE]];
    
    char *err;
    [self openDB];
    if (sqlite3_exec(db, [query UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        
        //sqlite3_close(db);
        NSLog(@"\n****** Not Posssible Insert New Record In %@, with error: '%s'", TABLE_NAME_DEFIBRILLATORI, err);
        return NO;
    }
    return YES;

}

//************************************
#pragma mark - Count DB
//************************************

- (int)countOfDbFromDefibrillatori {
    return [self countOfDbFromTableNamed:TABLE_NAME_DEFIBRILLATORI];
}

- (int)countOfDbFromTableNamed:(NSString *)tableName {
    [self openDB];
    NSString * qsql = [NSString stringWithFormat:@"SELECT * FROM '%@'", tableName];
    sqlite3_stmt *statment;
    
    int count = 0;

    if (sqlite3_prepare_v2(db, [qsql UTF8String], -1, &statment, NULL) == SQLITE_OK) {
        
        while (sqlite3_step(statment) == SQLITE_ROW) {
            count ++;
        }
        //-- Delete the compiler statment from memory
        sqlite3_finalize(statment);
    }
    else
        NSLog(@"****** Error Count of DB");
    return count;
}

//************************************
#pragma mark - Get Oggetti
//************************************

/**
 @deprecated Metodo da cancellare.
 */
- (NSArray *)allObjects{
    [self openDB];
    NSString * qsql = [NSString stringWithFormat:@"SELECT * FROM '%@'", TABLE_NAME_DEFIBRILLATORE];
    sqlite3_stmt *statment;
    
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    
    if (sqlite3_prepare_v2(db, [qsql UTF8String], -1, &statment, nil) == SQLITE_OK) {
        
        while (sqlite3_step(statment) == SQLITE_ROW) {
            NSMutableArray *tempArray = [[[NSMutableArray alloc] init] autorelease];

            char *charValue;
            NSString *strValue = [[NSString alloc] autorelease];
            
            //Cartelli
            charValue = (char *) sqlite3_column_text(statment, 1);
            strValue = [strValue initWithUTF8String:charValue];
            [tempArray addObject:strValue];

            //Categoria
            charValue = (char *) sqlite3_column_text(statment, 2);
            strValue = [strValue initWithUTF8String:charValue];
            [tempArray addObject:strValue];

            //Codice
            charValue = (char *) sqlite3_column_text(statment, 3);
            strValue = [strValue initWithUTF8String:charValue];
            [tempArray addObject:strValue];

            //Collocazione
            charValue = (char *) sqlite3_column_text(statment, 4);
            strValue = [strValue initWithUTF8String:charValue];
            [tempArray addObject:strValue];

            //Comune
            charValue = (char *) sqlite3_column_text(statment, 5);
            strValue = [strValue initWithUTF8String:charValue];
            [tempArray addObject:strValue];

            //Disponibilità
            charValue = (char *) sqlite3_column_text(statment, 6);
            strValue = [strValue initWithUTF8String:charValue];
            [tempArray addObject:strValue];

            //Immagine
            charValue = (char *) sqlite3_column_text(statment, 7);
            strValue = [strValue initWithUTF8String:charValue];
            [tempArray addObject:strValue];

            //Indirizzo
            charValue = (char *) sqlite3_column_text(statment, 8);
            strValue = [strValue initWithUTF8String:charValue];
            [tempArray addObject:strValue];

            //Latitudine
            charValue = (char *) sqlite3_column_text(statment, 9);
            strValue = [strValue initWithUTF8String:charValue];
            [tempArray addObject:strValue];

            //Localita
            charValue = (char *) sqlite3_column_text(statment, 10);
            strValue = [strValue initWithUTF8String:charValue];
            [tempArray addObject:strValue];

            //Longitudine
            charValue = (char *) sqlite3_column_text(statment, 11);
            strValue = [strValue initWithUTF8String:charValue];
            [tempArray addObject:strValue];

            //Mail
            charValue = (char *) sqlite3_column_text(statment, 12);
            strValue = [strValue initWithUTF8String:charValue];
            [tempArray addObject:strValue];

            //Modello
            charValue = (char *) sqlite3_column_text(statment, 13);
            strValue = [strValue initWithUTF8String:charValue];
            [tempArray addObject:strValue];

            //Nome
            charValue = (char *) sqlite3_column_text(statment, 14);
            strValue = [strValue initWithUTF8String:charValue];
            [tempArray addObject:strValue];

            //Note
            charValue = (char *) sqlite3_column_text(statment, 15);
            strValue = [strValue initWithUTF8String:charValue];
            [tempArray addObject:strValue];

            //OK
            charValue = (char *) sqlite3_column_text(statment, 16);
            strValue = [strValue initWithUTF8String:charValue];
            [tempArray addObject:strValue];

            //Provincia
            charValue = (char *) sqlite3_column_text(statment, 17);
            strValue = [strValue initWithUTF8String:charValue];
            [tempArray addObject:strValue];

            //Riferimento
            charValue = (char *) sqlite3_column_text(statment, 18);
            strValue = [strValue initWithUTF8String:charValue];
            [tempArray addObject:strValue];

            //Scandenza Batteria
            charValue = (char *) sqlite3_column_text(statment, 19);
            strValue = [strValue initWithUTF8String:charValue];
            [tempArray addObject:strValue];

            //Scadenza Elettrodi
            charValue = (char *) sqlite3_column_text(statment, 20);
            strValue = [strValue initWithUTF8String:charValue];
            [tempArray addObject:strValue];

            //Serie
            charValue = (char *) sqlite3_column_text(statment, 21);
            strValue = [strValue initWithUTF8String:charValue];
            [tempArray addObject:strValue];

            //Stato
            charValue = (char *) sqlite3_column_text(statment, 22);
            strValue = [strValue initWithUTF8String:charValue];
            [tempArray addObject:strValue];

            //Teca
            charValue = (char *) sqlite3_column_text(statment, 23);
            strValue = [strValue initWithUTF8String:charValue];
            [tempArray addObject:strValue];

            //Telefono Punto Blu
            charValue = (char *) sqlite3_column_text(statment, 24);
            strValue = [strValue initWithUTF8String:charValue];
            [tempArray addObject:strValue];

            //Telefono
            charValue = (char *) sqlite3_column_text(statment, 25);
            strValue = [strValue initWithUTF8String:charValue];
            [tempArray addObject:strValue];

            //Ultima Modifica
            charValue = (char *) sqlite3_column_text(statment, 26);
            strValue = [strValue initWithUTF8String:charValue];
            [tempArray addObject:strValue];
            
            //Ultima Verifica
            charValue = (char *) sqlite3_column_text(statment, 27);
            strValue = [strValue initWithUTF8String:charValue];
            [tempArray addObject:strValue];

            //Ultimo Corso
            charValue = (char *) sqlite3_column_text(statment, 28);
            strValue = [strValue initWithUTF8String:charValue];
            [tempArray addObject:strValue];
            
            [returnArray addObject:tempArray];
            
        }//end while
        sqlite3_finalize(statment);
    }//end if
    
    else
        NSLog(@"***** Error do not possible get all objs");
    
    if ([returnArray count] == 0) {
        
        NSLog(@"Non ci sono elementi nella tabella %@", TABLE_NAME_DEFIBRILLATORI);
    }
    //sort
    //return [Database sortWithArray:returnArray];

    return returnArray;
}

/**
 @description Prende le info da far vedere nella schermata di dettaglio.
 */
/// @avaible 
- (NSArray *)objects {
    [self openDB];
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    NSString * qsql = [NSString stringWithFormat:@"SELECT %@,%@,%@,%@,%@,%@ FROM %@",
                       KEY_DISPONIBILITA, KEY_LOCALITA, KEY_INDIRIZZO ,KEY_NOME, KEY_TELEFONO, KEY_TEL_PUNTO_BLU, TABLE_NAME_DEFIBRILLATORI];
    sqlite3_stmt *statment;    
    if (sqlite3_prepare_v2(db, [qsql UTF8String], -1, &statment, nil) == SQLITE_OK) {
        
        while (sqlite3_step(statment) == SQLITE_ROW) {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            NSString *strValue = [[[NSString alloc] init] autorelease];
            char *charValue;
            
            //-- Disponibilità
            charValue = (char *) sqlite3_column_text(statment, 0);
            strValue = [strValue initWithUTF8String:charValue];
            [dic setValue:strValue forKey:KEY_DISPONIBILITA];
            
            //-- Posizione/Località
            charValue = (char *) sqlite3_column_text(statment, 1);
            strValue = [strValue initWithUTF8String:charValue];
            [dic setValue:strValue forKey:KEY_LOCALITA];
            
            //-- Indirizzo
            charValue = (char *) sqlite3_column_text(statment, 2);
            strValue = [strValue initWithUTF8String:charValue];
            [dic setValue:strValue forKey:KEY_INDIRIZZO];
            
            //-- Nome Referente
            charValue = (char *) sqlite3_column_text(statment, 3);
            strValue = [strValue initWithUTF8String:charValue];
            [dic setValue:strValue forKey:KEY_NOME];
            
            //-- Telefono
            charValue = (char *) sqlite3_column_text(statment, 4);
            strValue = [strValue initWithUTF8String:charValue];
            [dic setValue:strValue forKey:KEY_TELEFONO];
            
            //-- Telefono Punto Blu
            charValue = (char *) sqlite3_column_text(statment, 5);
            strValue = [strValue initWithUTF8String:charValue];
            [dic setValue:strValue forKey:KEY_TEL_PUNTO_BLU];
            
            [returnArray addObject:dic];
        }//end while
        sqlite3_finalize(statment);
    }//end if
    else
        NSLog(@"***** Error do not possible get all objs");
    
    if ([returnArray count] == 0) {
        
        NSLog(@"Non ci sono elementi nella tabella %@", TABLE_NAME_DEFIBRILLATORI);
    }
    return returnArray;
}

/**
 @description Prende tutte le info da far vedere nella schermata di dettaglio + LE COORDINATE.
 */
- (NSArray *)objectsV2 {
    [self openDB];
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    NSString * qsql = [NSString stringWithFormat:@"SELECT %@,%@,%@,%@,%@,%@,%@,%@ FROM %@",
                       KEY_DISPONIBILITA, KEY_LOCALITA, KEY_INDIRIZZO ,KEY_NOME, KEY_TELEFONO, KEY_TEL_PUNTO_BLU, KEY_LATITUDINE, KEY_LONGITUDINE, TABLE_NAME_DEFIBRILLATORI];
    sqlite3_stmt *statment;
    if (sqlite3_prepare_v2(db, [qsql UTF8String], -1, &statment, nil) == SQLITE_OK) {
        
        while (sqlite3_step(statment) == SQLITE_ROW) {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            NSString *strValue = [[[NSString alloc] init] autorelease];
            char *charValue;

            //-- Disponibilità
            charValue = (char *) sqlite3_column_text(statment, 0);
            strValue = [strValue initWithUTF8String:charValue];
            [dic setValue:strValue forKey:KEY_DISPONIBILITA];
            
            //-- Posizione/Località
            charValue = (char *) sqlite3_column_text(statment, 1);
            strValue = [strValue initWithUTF8String:charValue];
            [dic setValue:strValue forKey:KEY_LOCALITA];
            
            //-- Indirizzo
            charValue = (char *) sqlite3_column_text(statment, 2);
            strValue = [strValue initWithUTF8String:charValue];
            [dic setValue:strValue forKey:KEY_INDIRIZZO];
            
            //-- Nome Referente
            charValue = (char *) sqlite3_column_text(statment, 3);
            strValue = [strValue initWithUTF8String:charValue];
            [dic setValue:strValue forKey:KEY_NOME];
            
            //-- Telefono
            charValue = (char *) sqlite3_column_text(statment, 4);
            strValue = [strValue initWithUTF8String:charValue];
            [dic setValue:strValue forKey:KEY_TELEFONO];
            
            //-- Telefono Punto Blu
            charValue = (char *) sqlite3_column_text(statment, 5);
            strValue = [strValue initWithUTF8String:charValue];
            [dic setValue:strValue forKey:KEY_TEL_PUNTO_BLU];
            
            //-- Latutudine
            charValue = (char *) sqlite3_column_text(statment, 6);
            strValue = [strValue initWithUTF8String:charValue];
            [dic setValue:strValue forKey:KEY_LATITUDINE];

            //-- Longitudie
            charValue = (char *) sqlite3_column_text(statment, 7);
            strValue = [strValue initWithUTF8String:charValue];
            [dic setValue:strValue forKey:KEY_LONGITUDINE];
            
            
            [returnArray addObject:dic];
        }//end while
        sqlite3_finalize(statment);
    }//end if
    else
        NSLog(@"***** Error do not possible get all objs");
    
    if ([returnArray count] == 0) {
        
        NSLog(@"Non ci sono elementi nella tabella %@", TABLE_NAME_DEFIBRILLATORI);
    }
    return returnArray;
}

+ (NSMutableArray *)sortWithArray:(NSMutableArray *)mArray {
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:mArray];
    CLLocation *location = [LibLocation location];
    
    NSLog(@"INIZIO + sortWithArray1");
    for (int i=0; tempArray.count != 0; i++){
        int index = [self minInArray:tempArray withI:0 withZ:tempArray.count - 1 withCurrentPosition:location];
        [returnArray addObject:[tempArray objectAtIndex:index]];
        [tempArray removeObjectAtIndex:index];
    }
    NSLog(@"FINE");
    
    return returnArray;
}

//TODO: Sto lavorando qui
+ (NSMutableArray *)sortWithArray2:(NSMutableArray *)mArray {
    
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:mArray];
    CLLocation *location = [LibLocation location];
    
    NSLog(@"INIZIO + sortWithArray1");
    for (int i=0; tempArray.count != 0; i++){ //TODO: Cambiare tipo di for.
        int index = [self minInArray2:tempArray withI:0 withZ:tempArray.count - 1 withCurrentPosition:location];
        [returnArray addObject:[tempArray objectAtIndex:index]];
        [tempArray removeObjectAtIndex:index];
    }
    NSLog(@"FINE");
    
    return returnArray;
}

+ (int)minInArray2:(NSArray *)array withI:(int)i withZ:(int)z withCurrentPosition:(CLLocation *)currentPosition{
    
    if (i==z) {
        return i;
    }
    if (z == i+1) {
        CLLocation *location1 = [[CLLocation alloc] initWithLatitude:[[[array objectAtIndex:i] valueForKey:KEY_LATITUDINE] doubleValue] longitude:[[[array objectAtIndex:i] valueForKey:KEY_LONGITUDINE] doubleValue]];
        CLLocation *location2 = [[CLLocation alloc] initWithLatitude:[[[array objectAtIndex:i+1] valueForKey:KEY_LATITUDINE] doubleValue] longitude:[[[array objectAtIndex:i+1] valueForKey:KEY_LONGITUDINE] doubleValue]];
        
        if ([currentPosition distanceFromLocation:location1] < [currentPosition distanceFromLocation:location2]){
            return i;
        }
        else {
            return i+1;
        }
    }
    else {
        int m = (i + z) / 2;
        int sx = [self minInArray2:array withI:i withZ:m withCurrentPosition:currentPosition];
        int dx = [self minInArray2:array withI:m+1 withZ:z withCurrentPosition:currentPosition];
        
        CLLocation *locationDX = [[CLLocation alloc] initWithLatitude:[[[array objectAtIndex:dx] valueForKey:KEY_LATITUDINE] doubleValue] longitude:[[[array objectAtIndex:dx] valueForKey:KEY_LONGITUDINE] doubleValue]];
        CLLocation *locationSX = [[CLLocation alloc] initWithLatitude:[[[array objectAtIndex:sx] valueForKey:KEY_LATITUDINE] doubleValue] longitude:[[[array objectAtIndex:sx] valueForKey:KEY_LONGITUDINE] doubleValue]];
        
        if ([currentPosition distanceFromLocation:locationDX] < [currentPosition distanceFromLocation:locationSX])
            return dx;
        else
            return sx;
    }
}


+ (int)minInArray:(NSArray *)array withI:(int)i withZ:(int)z withCurrentPosition:(CLLocation *)currentPosition{
    
    if (i==z) {
        return i;
    }
    if (z == i+1) {
        CLLocation *location1 = [[CLLocation alloc] initWithLatitude:[[[array objectAtIndex:i] objectAtIndex:8] doubleValue] longitude:[[[array objectAtIndex:i] objectAtIndex:10] doubleValue]];
        CLLocation *location2 = [[CLLocation alloc] initWithLatitude:[[[array objectAtIndex:i+1] objectAtIndex:8] doubleValue] longitude:[[[array objectAtIndex:i+1] objectAtIndex:10] doubleValue]];
        
        if ([currentPosition distanceFromLocation:location1] < [currentPosition distanceFromLocation:location2]){
            return i;
        }
        else {
            return i+1;
        }
    }
    else {
        int m = (i + z) / 2;
        int sx = [self minInArray:array withI:i withZ:m withCurrentPosition:currentPosition];
        int dx = [self minInArray:array withI:m+1 withZ:z withCurrentPosition:currentPosition];
        
        CLLocation *locationDX = [[CLLocation alloc] initWithLatitude:[[[array objectAtIndex:dx] objectAtIndex:8] doubleValue] longitude:[[[array objectAtIndex:dx] objectAtIndex:10] doubleValue]];
        CLLocation *locationSX = [[CLLocation alloc] initWithLatitude:[[[array objectAtIndex:sx] objectAtIndex:8] doubleValue] longitude:[[[array objectAtIndex:sx] objectAtIndex:10] doubleValue]];
        
        if ([currentPosition distanceFromLocation:locationDX] < [currentPosition distanceFromLocation:locationSX])
            return dx;
        else
            return sx;
    }
}

/**
    Ritorna un array di CLLoation con tutte le coordinate inserite (!= 0)
 */
- (NSArray *)allLocation{
    [self openDB];
    
    NSString * qsql = [NSString stringWithFormat:@"SELECT %@,%@ FROM '%@'", KEY_LATITUDINE, KEY_LONGITUDINE, TABLE_NAME_DEFIBRILLATORI];
    sqlite3_stmt *statment;
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    
    if (sqlite3_prepare_v2(db, [qsql UTF8String], -1, &statment, nil) == SQLITE_OK) {
        
        while (sqlite3_step(statment) == SQLITE_ROW) {

            double latitude = sqlite3_column_double(statment, 0);
            double longitude = sqlite3_column_double(statment, 1);

            if ((latitude && longitude) != 0) {
                CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
                [returnArray addObject:location];
            }

        }//end while
        sqlite3_finalize(statment);
    }//end if
    else
        NSLog(@"***** Error do not possible get all objs");
    
    if ([returnArray count] == 0) {
        
        NSLog(@"Non ci sono elementi nella tabella %@", TABLE_NAME_DEFIBRILLATORI);
    }
    return returnArray;
}


//************************************
#pragma mark - Delete Methods
//************************************

- (char *)DeleteTable:(NSString *)table {
    
    NSString *query = [NSString stringWithFormat:@"DROP TABLE \"main\".\"%@\"", table];
    char *err;
    if (sqlite3_exec(db, [query UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        
        sqlite3_close(db);
        NSLog(@"****** Error Delete table %@, with error. '%s'", table,err);
    }
    return err;
}


@end
