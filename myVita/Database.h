//
//  Database.h
//  myVita
//
//  Created by Marco Velluto on 26/03/13.
//  Copyright (c) 2013 Algos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"

static NSString * const KEY_CARTELLI = @"cartelli"; //ok
static NSString * const KEY_CATEGORIA = @"categoria"; //ok
static NSString * const KEY_CODICE = @"codice";
static NSString * const KEY_COLLOCAZIONE = @"collocazione"; //ok
static NSString * const KEY_COMUNE = @"comune"; //ok
static NSString * const KEY_DISPONIBILITA = @"disponibilita"; //ok
static NSString * const KEY_IMMAGINE = @"immagine";
static NSString * const KEY_INDIRIZZO = @"indirizzo"; //ok
static NSString * const KEY_LATITUDINE = @"latitudine"; //ok
static NSString * const KEY_LOCALITA = @"localita"; // ok
static NSString * const KEY_LONGITUDINE = @"longitudine"; //ok
static NSString * const KEY_MAIL = @"mail"; //ok
static NSString * const KEY_MODELLO = @"modello"; //ok
static NSString * const KEY_NOME = @"nome"; //ok
static NSString * const KEY_NOTE = @"note"; //ok
static NSString * const KEY_OK = @"ok"; //ok
static NSString * const KEY_PROVINCIA = @"provincia"; //ok
static NSString * const KEY_RIFERIMENTO = @"riferimento"; //ok
static NSString * const KEY_SCAD_BATT = @"scadenzaBatteria";
static NSString * const KEY_SCAD_ELET = @"scadenzaElettrodi";
static NSString * const KEY_SERIE = @"serie";
static NSString * const KEY_STATO = @"stato";
static NSString * const KEY_TECA = @"teca";
static NSString * const KEY_TELEFONO = @"telefono";
static NSString * const KEY_TEL_PUNTO_BLU = @"telpuntoblu";
static NSString * const KEY_ULTIMA_VERIFICA = @"ultimaVerifica";
static NSString * const KEY_ULTIMA_MODIFICA = @"ultimamodifica"; //integer
static NSString * const KEY_ULTIMO_CORSO = @"ultimoCorso";

@interface Database : NSObject {
    
    sqlite3 *db;
}

- (void) openDB;
- (void)createTableNamedDefibrillatori;
- (void)createTableDefibrillatore;
- (void)riempiTabella:(NSArray *)array;
- (NSArray *)allObjects;
- (char *)DeleteTable:(NSString *)table;
- (void)insertRecordWithDefibrillatore:(NSDictionary *)dicDefibrillatori;



@end
