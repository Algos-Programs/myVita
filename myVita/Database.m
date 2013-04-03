//
//  Database.m
//  myVita
//
//  Created by Marco Velluto on 26/03/13.
//  Copyright (c) 2013 Algos. All rights reserved.
//

#import "Database.h"

@implementation Database

static NSString * const TABLE_NAME_DEFIBRILLATORI = @"Defibrillatori";
static NSString * const TABLE_NAME_DEFIBRILLATORE = @"Defibrillatore";

- (NSString *) filePath {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    
    return [documentsDir stringByAppendingPathComponent:@"databaseP.sql"];
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

- (void)createTableNamedDefibrillatori {
    
    char *err;
    NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' "
                     "INTEGER PRIMARY KEY, '%@' TEXT, '%@' INT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' REAL, '%@' REAL, '%@' INTEGER);",
                     TABLE_NAME_DEFIBRILLATORI, @"id", @"Prov", @"Cap", @"Comune", @"Fraz", @"Indirizzo", @"Nome", @"Orario", @"Accesso", @"Rif", @"Tel", @"Latitudine", @"Longitudine", @"OK"];
    
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        
        sqlite3_close(db);
        NSLog(@"Table %@ falied create.", TABLE_NAME_DEFIBRILLATORI);
    }
}

- (void)createTableNamedDefibrillatore {
    
    char *err;
    NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' "
                     "INTEGER PRIMARY KEY, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' REAL, '%@' TEXT, '%@' REAL, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' INTEGER, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT);",
                     TABLE_NAME_DEFIBRILLATORE,
                     @"id",
                     @"statoBatteria",
                     @"cartelli",
                     @"categoria",
                     @"collocazione",
                     @"comune", @"corso",
                     @"disponibilita",
                     @"scaElettrodi",
                     @"indirizzo",
                     @"latitudine",
                     @"posizione",
                     @"longitudine",
                     @"mail",
                     @"modello",
                     @"nome",
                     @"note",
                     @"ok",
                     @"provincia",
                     @"riferimento",
                     @"serie",
                     @"stato",
                     @"teca",
                     @"telefono",
                     @"telPuntoBlu",
                     @"verifica"];
    
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        
        sqlite3_close(db);
        NSLog(@"Table %@ falied create.", TABLE_NAME_DEFIBRILLATORI);
    }
}


//************************************
#pragma mark - Inseriemento Oggetti
//************************************
/*
- (void) insertRecordWithDefibrillatori:(MDefibrillatore *)defibrillatore {
    int countOfDb = 0;
    countOfDb = [self countOfDb] + 1;
    NSString *sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO '%@' ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')"
                  "VALUES ('%d','%@','%d','%@','%@','%@','%@','%@','%@','%@','%@','%f','%f','%i')", TABLE_NAME_DEFIBRILLATORI,
                     @"id", //1
                     @"Prov", //2
                     @"Comune", //4
                     @"Fraz", //5
                     @"Indirizzo", //6
                     @"Nome", //7
                     @"Orario", //8
                     @"Accesso", //9
                     @"Rif", //10
                     @"Tel", //11
                     @"Latitudine", //12
                     @"Longitudine", //13
                     @"OK", //14
                     
                     countOfDb, //1-id
                     defibrillatore.provincia, //2-Prov
                     defibrillatore.comune,//4 - Comune
                     defibrillatore.frazione, //5 - Frazione
                     defibrillatore.indirizzo,//6 - Indirizzo
                     defibrillatore.nome, //7 - Nome
                     defibrillatore.orario, // 8 - Orario
                     defibrillatore.accesso, //9 - Accesso
                     defibrillatore.riferimento, //10 - Riferimento
                     defibrillatore.tel, //11 - Telefono
                     defibrillatore.latitudine, //12 - Lat
                     defibrillatore.longitudine, //13 - Lon
                     (int)defibrillatore.ok]; //14 - ok
    
    char *err;
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        
        sqlite3_close(db);
        NSLog(@"****** Not Posssible Insert New Record In %@, with error: '%s'", TABLE_NAME_DEFIBRILLATORI,err);
    }
}
*/
- (void)insertRecordWithDefibrillatore:(NSArray *)arrDefibrillatore {
    
    int countOfDb = 0;
    countOfDb = [self countOfDb] + 1;
    NSString *sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO '%@' ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')"
                     "VALUES ('%d','%@','%@','%@','%@','%@','%@','%@','%@','%@','%f','%@','%f','%@','%@','%@','%@','%i','%@','%@','%@','%@','%@','%@','%@','%@')",
                     TABLE_NAME_DEFIBRILLATORE,
                     @"id",
                     @"statoBatteria",
                     @"cartelli",
                     @"categoria",
                     @"collocazione",
                     @"comune", @"corso",
                     @"disponibilita",
                     @"scaElettrodi",
                     @"indirizzo",
                     @"latitudine",
                     @"posizione",
                     @"longitudine",
                     @"mail",
                     @"modello",
                     @"nome",
                     @"note",
                     @"ok",
                     @"provincia",
                     @"riferimento",
                     @"serie",
                     @"stato",
                     @"teca",
                     @"telefono",
                     @"telPuntoBlu",
                     @"verifica",
    
                     countOfDb, //1-id
    [arrDefibrillatore objectAtIndex:0],
    [arrDefibrillatore objectAtIndex:1],
    [arrDefibrillatore objectAtIndex:2],
    [arrDefibrillatore objectAtIndex:3],
    [arrDefibrillatore objectAtIndex:4],
    [arrDefibrillatore objectAtIndex:5],
    [arrDefibrillatore objectAtIndex:6],
    [arrDefibrillatore objectAtIndex:7],
    [arrDefibrillatore objectAtIndex:8],
    [[arrDefibrillatore objectAtIndex:9] floatValue],
    [arrDefibrillatore objectAtIndex:10],
    [[arrDefibrillatore objectAtIndex:11] floatValue],
    [arrDefibrillatore objectAtIndex:12],
    [arrDefibrillatore objectAtIndex:13],
    [arrDefibrillatore objectAtIndex:14],
    [arrDefibrillatore objectAtIndex:15],
    [[arrDefibrillatore objectAtIndex:16] integerValue],
    [arrDefibrillatore objectAtIndex:17],
    [arrDefibrillatore objectAtIndex:18],
    [arrDefibrillatore objectAtIndex:19],
    [arrDefibrillatore objectAtIndex:20],
    [arrDefibrillatore objectAtIndex:21],
    [arrDefibrillatore objectAtIndex:22],
    [arrDefibrillatore objectAtIndex:23],
                     [arrDefibrillatore objectAtIndex:24]];
    
    char *err;
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        
        sqlite3_close(db);
        NSLog(@"****** Not Posssible Insert New Record In %@, with error: '%s'", TABLE_NAME_DEFIBRILLATORE, err);
    }
    
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
    if (sqlite3_prepare_v2(db, [qsql UTF8String], -1, &statment, nil) == SQLITE_OK) {
        
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
    
    NSString * qsql = [NSString stringWithFormat:@"SELECT * FROM '%@'", TABLE_NAME_DEFIBRILLATORI];
    sqlite3_stmt *statment;
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    
    if (sqlite3_prepare_v2(db, [qsql UTF8String], -1, &statment, nil) == SQLITE_OK) {
        
        while (sqlite3_step(statment) == SQLITE_ROW) {
            
            
            
            //Provincia
            char *prov = (char *) sqlite3_column_text(statment, 1);
            NSString *provStr = [[NSString alloc] initWithUTF8String:prov];
            
            //CAP
            int cap = (int)sqlite3_column_int(statment, 2);
            
            //Comune
            char *comune = (char *) sqlite3_column_text(statment, 3);
            NSString *comuneStr = [[NSString alloc] initWithUTF8String:comune];
            
            
            //Frazione
            char *frazione = (char *) sqlite3_column_text(statment, 4);
            NSString *frazioneStr = [[NSString alloc] initWithUTF8String:frazione];
            
            
            //Indirizzo
            char *indirizzo = (char *) sqlite3_column_text(statment, 5);
            NSString *indirizzoStr = [[NSString alloc] initWithUTF8String:indirizzo];
            
            //Nome
            char *nome = (char *) sqlite3_column_text(statment, 6);
            NSString *nomeStr = [[NSString alloc] initWithUTF8String:nome];

            //Orario
            char *orario = (char *) sqlite3_column_text(statment, 7);
            NSString *orarioStr = [[NSString alloc] initWithUTF8String:orario];

            //Accesso
            char *accesso = (char *) sqlite3_column_text(statment, 8);
            NSString *accessoStr = [[NSString alloc] initWithUTF8String:accesso];

            //Riferimento
            char *riferimento = (char *) sqlite3_column_text(statment, 9);
            NSString *riferimentoStr = [[NSString alloc] initWithUTF8String:riferimento];

            //Telefono
            char *telefono = (char *) sqlite3_column_text(statment, 10);
            NSString *telefonoStr = [[NSString alloc] initWithUTF8String:telefono];

            //Latitudine
            double latitudine = (double) sqlite3_column_double(statment, 11);
            
            //Longitudine
            double longitudine = (double) sqlite3_column_double(statment, 12);
            
            //OK
            Boolean ok = (Boolean) sqlite3_column_int(statment, 13);
            
            
        }//end while
        sqlite3_finalize(statment);
    }//end if
    else
        NSLog(@"***** Error do not possible get all objs");
    
    if ([tempArray count] == 0) {
        
        NSLog(@"Non ci sono elementi nella tabella %@", TABLE_NAME_DEFIBRILLATORI);
    }
    return tempArray;
}

@end
