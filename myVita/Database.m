
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

/**
 @deprecated Obsoleto utilizzare createTableDefibrillatoi:
 */
- (void)createTableDefibrillatore __attribute__ ((deprecated)) {
    
    char *err;
    NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' "
                     "INTEGER PRIMARY KEY, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' REAL, '%@' TEXT, '%@' REAL, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' INTEGER, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' INTEGER, '%@' TEXT);",
                     TABLE_NAME_DEFIBRILLATORE,
                     @"id", //0
                     KEY_CARTELLI,//1
                     KEY_CATEGORIA,//2
                     KEY_CODICE,//3
                     KEY_COLLOCAZIONE,//4
                     KEY_COMUNE,//5
                     KEY_DISPONIBILITA,//6
                     KEY_IMMAGINE,//7
                     KEY_INDIRIZZO,//8
                     KEY_LATITUDINE,//9
                     KEY_LOCALITA,//10
                     KEY_LONGITUDINE, //11
                     KEY_MAIL,
                     KEY_MODELLO,
                     KEY_NOME,
                     KEY_NOTE,
                     KEY_OK,
                     KEY_PROVINCIA,
                     KEY_RIFERIMENTO,
                     KEY_SCAD_BATT,
                     KEY_SCAD_ELET,
                     KEY_SERIE,
                     KEY_STATO,
                     KEY_TECA,
                     KEY_TEL_PUNTO_BLU,
                     KEY_TELEFONO,
                     KEY_ULTIMA_MODIFICA,
                     KEY_ULTIMA_VERIFICA,
                     KEY_ULTIMO_CORSO];
    
    
    [self openDB];    
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        
        sqlite3_close(db);
        NSLog(@"*****ERRORE:Table %@ falied create. - %s", TABLE_NAME_DEFIBRILLATORE, err);
    }
} 

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

/**
 @deprecated Obsoleto utilizzare insertRecord:
 */
- (BOOL)insertRecordWithDefibrillatore:(NSDictionary *)dicDefibrillatori {
    
    int countOfDb = 0;
    countOfDb = [self countOfDb] + 1;
    int ultimaModifica = 0;
    
    //-- Controllo 
    if ([dicDefibrillatori objectForKey:KEY_ULTIMA_MODIFICA] == NULL) {
        ultimaModifica = 0;
    }
    else
        ultimaModifica = (int)[dicDefibrillatori objectForKey:KEY_ULTIMA_MODIFICA];
    
    NSString *str = [dicDefibrillatori objectForKey:KEY_STATO];
    str = [str stringByReplacingOccurrencesOfString:@"'" withString:@""];
    
    //-- Controllo
    
    NSString *sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO '%@' ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')"
                     "VALUES ('%d','%@','%@','%d','%@','%@','%@','%@','%@','%f','%@','%f','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%d','%f','%@')",
                     TABLE_NAME_DEFIBRILLATORE,
                     @"id", //1
                     KEY_CARTELLI,//2
                     KEY_CATEGORIA,//3
                     KEY_CODICE,//4
                     KEY_COLLOCAZIONE,//5
                     KEY_COMUNE,//6
                     KEY_DISPONIBILITA, //7
                     KEY_IMMAGINE,//8
                     KEY_INDIRIZZO,//9
                     KEY_LATITUDINE,//10
                     KEY_LOCALITA,//11
                     KEY_LONGITUDINE,//12
                     KEY_MAIL,//13
                     KEY_MODELLO,//14
                     KEY_NOME,//15
                     KEY_NOTE,//16
                     KEY_OK,//17
                     KEY_PROVINCIA, //18
                     KEY_RIFERIMENTO, //19
                     KEY_SCAD_BATT, //20
                     KEY_SCAD_ELET, //21
                     KEY_SERIE, //22
                     KEY_STATO, //23
                     KEY_TECA, //24
                     KEY_TEL_PUNTO_BLU, //25
                     KEY_TELEFONO, //26
                     KEY_ULTIMA_MODIFICA, //27
                     KEY_ULTIMA_VERIFICA, //28
                     KEY_ULTIMO_CORSO, // 29
    
                                        
                     countOfDb, //0-id
                     [[dicDefibrillatori objectForKey:KEY_CARTELLI] stringByReplacingOccurrencesOfString:@"'" withString:@""], //1
                     [[dicDefibrillatori objectForKey:KEY_CATEGORIA] stringByReplacingOccurrencesOfString:@"'" withString:@""], //2
                     [[dicDefibrillatori objectForKey:KEY_CODICE] integerValue], //3
                     [[dicDefibrillatori objectForKey:KEY_COLLOCAZIONE] stringByReplacingOccurrencesOfString:@"'" withString:@""], //4
                     [[dicDefibrillatori objectForKey:KEY_COMUNE] stringByReplacingOccurrencesOfString:@"'" withString:@""], //5
                     [[dicDefibrillatori objectForKey:KEY_DISPONIBILITA] stringByReplacingOccurrencesOfString:@"'" withString:@""], //6
                     [dicDefibrillatori objectForKey:KEY_IMMAGINE], //7
                     [[dicDefibrillatori objectForKey:KEY_INDIRIZZO] stringByReplacingOccurrencesOfString:@"'" withString:@""], //8
                     [[dicDefibrillatori objectForKey:KEY_LATITUDINE] floatValue], //9
                     [[dicDefibrillatori objectForKey:KEY_LOCALITA] stringByReplacingOccurrencesOfString:@"'" withString:@""], //10
                     [[dicDefibrillatori objectForKey:KEY_LONGITUDINE] floatValue],//11
                     [dicDefibrillatori objectForKey:KEY_MAIL],//12
                     [[dicDefibrillatori objectForKey:KEY_MODELLO] stringByReplacingOccurrencesOfString:@"'" withString:@""],//13
                     [[dicDefibrillatori objectForKey:KEY_NOME] stringByReplacingOccurrencesOfString:@"'" withString:@""],//14
                     [[dicDefibrillatori objectForKey:KEY_NOTE] stringByReplacingOccurrencesOfString:@"'" withString:@""],//15
                     [dicDefibrillatori objectForKey:KEY_OK],//16
                     [[dicDefibrillatori objectForKey:KEY_PROVINCIA] stringByReplacingOccurrencesOfString:@"'" withString:@""],//17
                     [[dicDefibrillatori objectForKey:KEY_RIFERIMENTO] stringByReplacingOccurrencesOfString:@"'" withString:@""],//18
                     [dicDefibrillatori objectForKey:KEY_SCAD_BATT],//19
                     [dicDefibrillatori objectForKey:KEY_SCAD_ELET],//20
                     [[dicDefibrillatori objectForKey:KEY_SERIE] stringByReplacingOccurrencesOfString:@"'" withString:@""],//21
                     str, //22
                     [[dicDefibrillatori objectForKey:KEY_TECA] stringByReplacingOccurrencesOfString:@"'" withString:@""], //23
                     [dicDefibrillatori objectForKey:KEY_TEL_PUNTO_BLU], //24
                     [dicDefibrillatori objectForKey:KEY_TELEFONO], //25
                     ultimaModifica,
                     0.0, //(long)[[dicDefibrillatori objectForKey:KEY_ULTIMA_VERIFICA] integerValue]
                     [[dicDefibrillatori objectForKey:KEY_ULTIMO_CORSO] stringByReplacingOccurrencesOfString:@"'" withString:@"\'"]];

    
    char *err;
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        
        //sqlite3_close(db);
        NSLog(@"\n****** Not Posssible Insert New Record In %@, with error: '%s'", TABLE_NAME_DEFIBRILLATORE, err);
        return NO;
    }
    return YES;
}

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
                       [[dicDefibrillatori objectForKey:KEY_STATO] stringByReplacingOccurrencesOfString:@"'" withString:@""], //STATO
                       [dicDefibrillatori objectForKey:KEY_TELEFONO],
                       [dicDefibrillatori objectForKey:KEY_TEL_PUNTO_BLU],
                       [dicDefibrillatori objectForKey:KEY_LAST_UPDATE]];
//    [[dicDefibrillatori objectForKey:KEY_CATEGORIA] stringValue],
//    [[dicDefibrillatori objectForKey:KEY_CODICE] intValue],
//    [[dicDefibrillatori objectForKey:KEY_COMUNE] stringValue],
//    [[dicDefibrillatori objectForKey:KEY_DISPONIBILITA] stringValue],
//    [[dicDefibrillatori objectForKey:KEY_IMMAGINE] stringValue],
//    [[dicDefibrillatori objectForKey:KEY_INDIRIZZO] stringValue],
//    [[dicDefibrillatori objectForKey:KEY_LATITUDINE] doubleValue],
//    [[dicDefibrillatori objectForKey:KEY_LOCALITA] stringValue],
//    [[dicDefibrillatori objectForKey:KEY_LONGITUDINE] doubleValue],
//    [[dicDefibrillatori objectForKey:KEY_MAIL] stringValue],
//    [[dicDefibrillatori objectForKey:KEY_NOME] stringValue],
//    [[dicDefibrillatori objectForKey:KEY_OK] intValue],
//    [[dicDefibrillatori objectForKey:KEY_SCAD_BATT] stringValue],
//    [[dicDefibrillatori objectForKey:KEY_SCAD_ELET] stringValue],
//    [[dicDefibrillatori objectForKey:KEY_STATO] stringValue],
//    [[dicDefibrillatori objectForKey:KEY_TELEFONO] stringValue],
//    [[dicDefibrillatori objectForKey:KEY_TEL_PUNTO_BLU] stringValue],
//    [[dicDefibrillatori objectForKey:KEY_LAST_UPDATE] doubleValue]];
    
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

/**
 @deprecated Obsoleto utilizzare countOfDbFromDefibrillatori.
 */
- (int)countOfDb {
    
    return [self countOfDbFromTableNamed:TABLE_NAME_DEFIBRILLATORE];
}

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

/**
 Ritorna un array di dictionary dove sono presenti tutti gli oggetti con COORDINATE > 0
 */
- (NSArray *)objectsV3 {
    [self openDB];
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    NSString * qsql = [NSString stringWithFormat:@"SELECT %@,%@,%@,%@,%@,%@,%@,%@,%@ FROM %@ WHERE %@ > 0 AND %@ > 0",
                       KEY_DISPONIBILITA, KEY_LOCALITA, KEY_INDIRIZZO ,KEY_NOME, KEY_TELEFONO, KEY_TEL_PUNTO_BLU, KEY_LATITUDINE, KEY_LONGITUDINE, KEY_COMUNE, TABLE_NAME_DEFIBRILLATORI,KEY_LATITUDINE, KEY_LONGITUDINE];
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
            
            //-- Latitudine
            charValue = (char *) sqlite3_column_text(statment, 6);
            strValue = [strValue initWithUTF8String:charValue];
            [dic setValue:strValue forKey:KEY_LATITUDINE];
            
            //-- Longitudine
            charValue = (char *) sqlite3_column_text(statment, 7);
            strValue = [strValue initWithUTF8String:charValue];
            [dic setValue:strValue forKey:KEY_LONGITUDINE];
            
            //-- Telefono Punto Blu
            charValue = (char *) sqlite3_column_text(statment, 8);
            strValue = [strValue initWithUTF8String:charValue];
            [dic setValue:strValue forKey:KEY_COMUNE];
            
            
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
 Ritorna un array di dictionary dove sono presenti tutti gli oggetti con COORDINATE > 0 e il falg OK = SI.
 */
- (NSArray *)objectsV3WithOk {
    [self openDB];
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    NSString * qsql = [NSString stringWithFormat:@"SELECT %@,%@,%@,%@,%@,%@,%@,%@,%@ FROM %@ WHERE %@ > 0 AND %@ > 0 AND %@ == SI",
                       KEY_DISPONIBILITA, KEY_LOCALITA, KEY_INDIRIZZO ,KEY_NOME, KEY_TELEFONO, KEY_TEL_PUNTO_BLU, KEY_LATITUDINE, KEY_LONGITUDINE, KEY_COMUNE, TABLE_NAME_DEFIBRILLATORI,KEY_LATITUDINE, KEY_LONGITUDINE, KEY_OK];
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
            
            //-- Latitudine
            charValue = (char *) sqlite3_column_text(statment, 6);
            strValue = [strValue initWithUTF8String:charValue];
            [dic setValue:strValue forKey:KEY_LATITUDINE];
            
            //-- Longitudine
            charValue = (char *) sqlite3_column_text(statment, 7);
            strValue = [strValue initWithUTF8String:charValue];
            [dic setValue:strValue forKey:KEY_LONGITUDINE];
            
            //-- Telefono Punto Blu
            charValue = (char *) sqlite3_column_text(statment, 8);
            strValue = [strValue initWithUTF8String:charValue];
            [dic setValue:strValue forKey:KEY_COMUNE];
            
            
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

/**
    @param array -> è un array di dictionary
 */
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


- (NSArray *)allObjectsInDictionary __attribute__ ((deprecated)){
    
    NSString * qsql = [NSString stringWithFormat:@"SELECT %@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@ FROM '%@'", KEY_CARTELLI, KEY_CATEGORIA, KEY_CODICE, KEY_COLLOCAZIONE, KEY_COMUNE, KEY_DISPONIBILITA, KEY_IMMAGINE, KEY_INDIRIZZO, KEY_LAST_UPDATE, KEY_LATITUDINE, KEY_LOCALITA, KEY_LONGITUDINE, KEY_MAIL, KEY_MODELLO, KEY_NOME, KEY_NOTE, KEY_OK, KEY_PROVINCIA, KEY_RIFERIMENTO, KEY_SCAD_BATT, KEY_SCAD_ELET, KEY_SERIE, KEY_STATO, KEY_TECA, KEY_TEL_PUNTO_BLU, KEY_TELEFONO, KEY_ULTIMA_MODIFICA, KEY_ULTIMA_VERIFICA, KEY_ULTIMO_CORSO,TABLE_NAME_DEFIBRILLATORE];
    sqlite3_stmt *statment;
    
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    
    if (sqlite3_prepare_v2(db, [qsql UTF8String], -1, &statment, nil) == SQLITE_OK) {
        
        while (sqlite3_step(statment) == SQLITE_ROW) {
            NSMutableDictionary *tempDic = [[[NSMutableDictionary alloc] init] autorelease];
            
            char *charValue;
            NSString *strValue = [[NSString alloc] autorelease];
            
            charValue = (char *)sqlite3_column_text(statment, 0);
            strValue = [strValue initWithUTF8String:charValue];
            [tempDic setValue:strValue forKey:KEY_CARTELLI];

            charValue = (char *)sqlite3_column_text(statment, 1);
            strValue = [strValue initWithUTF8String:charValue];
            [tempDic setValue:strValue forKey:KEY_CATEGORIA];

            charValue = (char *)sqlite3_column_text(statment, 2); //INT
            strValue = [strValue initWithUTF8String:charValue];
            [tempDic setValue:strValue forKey:KEY_CODICE];

            charValue = (char *)sqlite3_column_text(statment, 3);
            strValue = [strValue initWithUTF8String:charValue];
            [tempDic setValue:strValue forKey:KEY_COLLOCAZIONE];

            charValue = (char *)sqlite3_column_text(statment, 4);
            strValue = [strValue initWithUTF8String:charValue];
            [tempDic setValue:strValue forKey:KEY_COMUNE];

            charValue = (char *)sqlite3_column_text(statment, 5);
            strValue = [strValue initWithUTF8String:charValue];
            [tempDic setValue:strValue forKey:KEY_DISPONIBILITA];

            charValue = (char *)sqlite3_column_text(statment, 6); //BLOB
            strValue = [strValue initWithUTF8String:charValue];
            [tempDic setValue:strValue forKey:KEY_IMMAGINE];

            charValue = (char *)sqlite3_column_text(statment, 7);
            strValue = [strValue initWithUTF8String:charValue];
            [tempDic setValue:strValue forKey:KEY_INDIRIZZO];

            charValue = (char *)sqlite3_column_text(statment, 8); //TIMESTAMP
            strValue = [strValue initWithUTF8String:charValue];
            [tempDic setValue:strValue forKey:KEY_LAST_UPDATE];

            charValue = (char *)sqlite3_column_text(statment, 9); //REAL
            strValue = [strValue initWithUTF8String:charValue];
            [tempDic setValue:strValue forKey:KEY_LATITUDINE];

            charValue = (char *)sqlite3_column_text(statment, 10);
            strValue = [strValue initWithUTF8String:charValue];
            [tempDic setValue:strValue forKey:KEY_LOCALITA];

            charValue = (char *)sqlite3_column_text(statment, 11); //REAL
            strValue = [strValue initWithUTF8String:charValue];
            [tempDic setValue:strValue forKey:KEY_LONGITUDINE];

            charValue = (char *)sqlite3_column_text(statment, 12);
            strValue = [strValue initWithUTF8String:charValue];
            [tempDic setValue:strValue forKey:KEY_MAIL];

            charValue = (char *)sqlite3_column_text(statment, 13); 
            strValue = [strValue initWithUTF8String:charValue];
            [tempDic setValue:strValue forKey:KEY_MODELLO];

            charValue = (char *)sqlite3_column_text(statment, 14);
            strValue = [strValue initWithUTF8String:charValue];
            [tempDic setValue:strValue forKey:KEY_NOME];

            charValue = (char *)sqlite3_column_text(statment, 15);
            strValue = [strValue initWithUTF8String:charValue];
            [tempDic setValue:strValue forKey:KEY_NOTE];
            
            charValue = (char *)sqlite3_column_text(statment, 16); //INT -> BOOL
            strValue = [strValue initWithUTF8String:charValue];
            [tempDic setValue:strValue forKey:KEY_OK];
            
            charValue = (char *)sqlite3_column_text(statment, 17);
            strValue = [strValue initWithUTF8String:charValue];
            [tempDic setValue:strValue forKey:KEY_PROVINCIA];
            
            charValue = (char *)sqlite3_column_text(statment, 18);
            strValue = [strValue initWithUTF8String:charValue];
            [tempDic setValue:strValue forKey:KEY_RIFERIMENTO];
            
            charValue = (char *)sqlite3_column_text(statment, 19);
            strValue = [strValue initWithUTF8String:charValue];
            [tempDic setValue:strValue forKey:KEY_SCAD_BATT];
            
            charValue = (char *)sqlite3_column_text(statment, 20);
            strValue = [strValue initWithUTF8String:charValue];
            [tempDic setValue:strValue forKey:KEY_SCAD_ELET];
            
            charValue = (char *)sqlite3_column_text(statment, 21);
            strValue = [strValue initWithUTF8String:charValue];
            [tempDic setValue:strValue forKey:KEY_SERIE];
            
            charValue = (char *)sqlite3_column_text(statment, 22);
            strValue = [strValue initWithUTF8String:charValue];
            [tempDic setValue:strValue forKey:KEY_STATO];
            
            charValue = (char *)sqlite3_column_text(statment, 23);
            strValue = [strValue initWithUTF8String:charValue];
            [tempDic setValue:strValue forKey:KEY_TECA];
            
            charValue = (char *)sqlite3_column_text(statment, 24);
            strValue = [strValue initWithUTF8String:charValue];
            [tempDic setValue:strValue forKey:KEY_TEL_PUNTO_BLU];
            
            charValue = (char *)sqlite3_column_text(statment, 25);
            strValue = [strValue initWithUTF8String:charValue];
            [tempDic setValue:strValue forKey:KEY_TELEFONO];
            
            charValue = (char *)sqlite3_column_text(statment, 26);
            strValue = [strValue initWithUTF8String:charValue];
            [tempDic setValue:strValue forKey:KEY_ULTIMA_MODIFICA];
            
            charValue = (char *)sqlite3_column_text(statment, 16);
            strValue = [strValue initWithUTF8String:charValue];
            [tempDic setValue:strValue forKey:KEY_ULTIMA_VERIFICA];
            
            charValue = (char *)sqlite3_column_text(statment, 27);
            strValue = [strValue initWithUTF8String:charValue];
            [tempDic setValue:strValue forKey:KEY_OK];
            
            charValue = (char *)sqlite3_column_text(statment, 28);
            strValue = [strValue initWithUTF8String:charValue];
            [tempDic setValue:strValue forKey:KEY_ULTIMO_CORSO];

            [returnArray addObject:tempDic];
            
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
