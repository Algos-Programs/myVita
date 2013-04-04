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

- (void)createTableDefibrillatore {
    
    char *err;
    NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' "
                     "INTEGER PRIMARY KEY, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' REAL, '%@' TEXT, '%@' REAL, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' INTEGER, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' INTEGER, '%@' TEXT);",
                     TABLE_NAME_DEFIBRILLATORE,
                     @"id",
                     KEY_CARTELLI,
                     KEY_CATEGORIA,
                     KEY_CODICE,
                     KEY_COLLOCAZIONE,
                     KEY_COMUNE,
                     KEY_DISPONIBILITA,
                     KEY_IMMAGINE,
                     KEY_INDIRIZZO,
                     KEY_LATITUDINE,
                     KEY_LOCALITA,
                     KEY_LONGITUDINE,
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
    
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        
        sqlite3_close(db);
        NSLog(@"*****ERRORE:Table %@ falied create. - %s", TABLE_NAME_DEFIBRILLATORI, err);
    }
}



//************************************
#pragma mark - Inseriemento Oggetti
//************************************
- (void)insertRecordWithDefibrillatore:(NSDictionary *)dicDefibrillatori {
    
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
    
                     
                     countOfDb, //1-id
                     [dicDefibrillatori objectForKey:KEY_CARTELLI],
                     [dicDefibrillatori objectForKey:KEY_CATEGORIA],
                     [[dicDefibrillatori objectForKey:KEY_CODICE] integerValue],
                     [dicDefibrillatori objectForKey:KEY_COLLOCAZIONE],
                     [dicDefibrillatori objectForKey:KEY_COMUNE],
                     [dicDefibrillatori objectForKey:KEY_DISPONIBILITA],
                     [dicDefibrillatori objectForKey:KEY_IMMAGINE],
                     [dicDefibrillatori objectForKey:KEY_INDIRIZZO],
                     [[dicDefibrillatori objectForKey:KEY_LATITUDINE] floatValue],
                     [dicDefibrillatori objectForKey:KEY_LOCALITA],
                     [[dicDefibrillatori objectForKey:KEY_LONGITUDINE] floatValue],
                     [dicDefibrillatori objectForKey:KEY_MAIL],
                     [dicDefibrillatori objectForKey:KEY_MODELLO],
                     [dicDefibrillatori objectForKey:KEY_NOME],
                     [dicDefibrillatori objectForKey:KEY_NOTE],
                     [dicDefibrillatori objectForKey:KEY_OK],
                     [dicDefibrillatori objectForKey:KEY_PROVINCIA],
                     [dicDefibrillatori objectForKey:KEY_RIFERIMENTO],
                     [dicDefibrillatori objectForKey:KEY_SCAD_BATT],
                     [dicDefibrillatori objectForKey:KEY_SCAD_ELET],
                     [dicDefibrillatori objectForKey:KEY_SERIE],
                     str,
                     [dicDefibrillatori objectForKey:KEY_TECA],
                     [dicDefibrillatori objectForKey:KEY_TEL_PUNTO_BLU],
                     [dicDefibrillatori objectForKey:KEY_TELEFONO],
                     ultimaModifica,
                     0.0, //(long)[[dicDefibrillatori objectForKey:KEY_ULTIMA_VERIFICA] integerValue]
                     [dicDefibrillatori objectForKey:KEY_ULTIMO_CORSO]];
    
    /*
                     countOfDb, //1-id
                     @"casa",
                     @"casa",
                     2,
                     @"casa",
                     @"casa",
                     @"casa",
                     @"casa",
                     @"casa",
                     3.0f,
                     @"casa",
                     9.8f,
                     @"casa",
                     @"casa",
                     @"casa",
                     @"casa",
                     @"casa",
                     @"casa",
                     @"casa",
                     @"casa",
                     @"casa",
                     @"casa",
                     @"casa",
                     @"casa",
                     @"casa",
                     @"casa",
                     3,
                     0.0, //(long)[[dicDefibrillatori objectForKey:KEY_ULTIMA_VERIFICA] integerValue]
                     @"casa"];
     */

    
    char *err;
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        
        sqlite3_close(db);
        NSLog(@"\n\nQUERY %@", sql);
        NSLog(@"\n****** Not Posssible Insert New Record In %@, with error: '%s'", TABLE_NAME_DEFIBRILLATORE, err);
    }
    
}

- (void)riempiTabella:(NSArray *)array {
    
    //-- Count of DB
    int countOfDb = 0;
    countOfDb = [self countOfDb] + 1;
    
    for (int i=0; i<array.count; i++) {
        NSDictionary *dic = [[NSDictionary alloc] init];
    }
    /*
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
    */

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
    
    NSString * qsql = [NSString stringWithFormat:@"SELECT * FROM '%@'", TABLE_NAME_DEFIBRILLATORE];
    sqlite3_stmt *statment;
    
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    
    if (sqlite3_prepare_v2(db, [qsql UTF8String], -1, &statment, nil) == SQLITE_OK) {
        
        while (sqlite3_step(statment) == SQLITE_ROW) {
            NSMutableArray *tempArray = [[NSMutableArray alloc] init];

            
            
            //Scadenza Batteria
            char *scaBat = (char *) sqlite3_column_text(statment, 1);
            NSString *scaBatStr = [[NSString alloc] initWithUTF8String:scaBat];
            [tempArray addObject:scaBatStr];
            
            //Cartelli
            char *cart = (char *) sqlite3_column_text(statment, 2);
            NSString *cartStr = [[NSString alloc] initWithUTF8String:cart];
            [tempArray addObject:cartStr];
            

            
            
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
