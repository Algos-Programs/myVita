
//
//  Database.m
//  myVita
//
//  Created by Marco Velluto on 26/03/13.
//  Copyright (c) 2013 Algos. All rights reserved.
//

#import "Database.h"
#import <CoreLocation/CoreLocation.h>

@implementation Database

static NSString * const TABLE_NAME_DEFIBRILLATORI = @"Defibrillatori";
static NSString * const TABLE_NAME_DEFIBRILLATORE = @"Defibrillatore";

- (NSString *) filePath {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    
    return [documentsDir stringByAppendingPathComponent:@"database.sql"];
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

- (void)createTableDefibrillatore {
    
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



//************************************
#pragma mark - Inseriemento Oggetti
//************************************

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
    
    int k =0;
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


- (BOOL)popolaTabellaWithArray:(NSArray *)arrDef {
    int ultimaModifica = 0;
    int index = 0;
    for (index=0; index<arrDef.count; index ++) {
        if (index == 29) {
            int k=0;
        }
        NSDictionary *dicDefibrillatori = [[NSDictionary alloc] initWithDictionary:[arrDef objectAtIndex:index]];
        
        //-- Controllo
        if ([dicDefibrillatori objectForKey:KEY_ULTIMA_MODIFICA] == NULL) {
            ultimaModifica = 0;
        }
        else
            ultimaModifica = (int)[dicDefibrillatori objectForKey:KEY_ULTIMA_MODIFICA];
        
        NSString *strStato = [dicDefibrillatori objectForKey:KEY_STATO];
        if (strStato != NULL) {
            strStato = [strStato stringByReplacingOccurrencesOfString:@"'" withString:@""];
        }
        
        
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
                         
                         
                         index, //0-id
                         [dicDefibrillatori objectForKey:KEY_CARTELLI], //1
                         [dicDefibrillatori objectForKey:KEY_CATEGORIA], //2
                         [[dicDefibrillatori objectForKey:KEY_CODICE] integerValue], //3
                         [dicDefibrillatori objectForKey:KEY_COLLOCAZIONE], //4
                         [dicDefibrillatori objectForKey:KEY_COMUNE], //5
                         [dicDefibrillatori objectForKey:KEY_DISPONIBILITA], //6
                         [dicDefibrillatori objectForKey:KEY_IMMAGINE], //7
                         [dicDefibrillatori objectForKey:KEY_INDIRIZZO], //8
                         [[dicDefibrillatori objectForKey:KEY_LATITUDINE] floatValue], //9
                         [dicDefibrillatori objectForKey:KEY_LOCALITA], //10
                         [[dicDefibrillatori objectForKey:KEY_LONGITUDINE] floatValue],//11
                         [dicDefibrillatori objectForKey:KEY_MAIL],//12
                         [dicDefibrillatori objectForKey:KEY_MODELLO],//13
                         [dicDefibrillatori objectForKey:KEY_NOME],//14
                         [dicDefibrillatori objectForKey:KEY_NOTE],//15
                         [dicDefibrillatori objectForKey:KEY_OK],//16
                         [dicDefibrillatori objectForKey:KEY_PROVINCIA],//17
                         [dicDefibrillatori objectForKey:KEY_RIFERIMENTO],//18
                         [dicDefibrillatori objectForKey:KEY_SCAD_BATT],//19
                         [dicDefibrillatori objectForKey:KEY_SCAD_ELET],//20
                         [dicDefibrillatori objectForKey:KEY_SERIE],//21
                         strStato, //22
                         [dicDefibrillatori objectForKey:KEY_TECA], //23
                         [dicDefibrillatori objectForKey:KEY_TEL_PUNTO_BLU], //24
                         [dicDefibrillatori objectForKey:KEY_TELEFONO], //25
                         ultimaModifica,
                         0.0, //(long)[[dicDefibrillatori objectForKey:KEY_ULTIMA_VERIFICA] integerValue]
                         [dicDefibrillatori objectForKey:KEY_ULTIMO_CORSO]];
        
        char *err;
        if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
            
            sqlite3_close(db);
            NSLog(@"\n****** Not Posssible Insert New Record In %@, with error: '%s'", TABLE_NAME_DEFIBRILLATORE, err);
            return NO;
        }
    }
    NSLog(@"%i", index);
    return YES;
}


//************************************
#pragma mark - Count DB
//************************************


- (int)countOfDb {
    
    return [self countOfDbFromTableNamed:TABLE_NAME_DEFIBRILLATORE];
}

- (int)countOfDbFromTableNamed:(NSString *)tableName {
    
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


- (NSArray *)allObjects{
    
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
    return returnArray;
}

/**
    Ritorna un array di CLLoation con tutte le coordinate inserite (!= 0)
 */
- (NSArray *)allLocation{
    [self openDB];
    
    NSString * qsql = [NSString stringWithFormat:@"SELECT %@,%@ FROM '%@'", KEY_LATITUDINE, KEY_LONGITUDINE, TABLE_NAME_DEFIBRILLATORE];
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


- (NSArray *)dictionaryWithAllObjects{
    
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
