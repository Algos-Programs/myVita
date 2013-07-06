//
//  Dae.h
//  myVita
//
//  Created by Marco Velluto on 01/07/13.
//  Copyright (c) 2013 Algos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Dae : NSObject

@property (nonatomic, strong) NSString *cartelli;
@property (nonatomic, strong) NSString *categoria;
@property (nonatomic, strong) NSString *collocazione;
@property (nonatomic, strong) NSString *comune;
@property (nonatomic, strong) NSString *disponibilita;
@property (nonatomic, strong) NSString *posizione;
@property (nonatomic, strong) NSString *indirizzo;
@property (nonatomic, strong) NSString *telefono;
@property (nonatomic, strong) NSString *localita;
@property (nonatomic, strong) NSString *mail;
@property (nonatomic, strong) NSString *modello;
@property (nonatomic, strong) NSString *nome;
@property (nonatomic, strong) NSString *note;
@property (nonatomic, strong) NSString *provincia;
@property (nonatomic, strong) NSString *riferimento;
@property (nonatomic, strong) NSString *scadenzaBatteria;
@property (nonatomic, strong) NSString *scadenzaElettrodi;
@property (nonatomic, strong) NSString *serie;
@property (nonatomic, strong) NSString *stato;
@property (nonatomic, strong) NSString *teca;
@property (nonatomic, strong) NSString *telefonoPuntoBlu;
@property (nonatomic, strong) NSString *ultimaModifica;
@property (nonatomic, strong) NSString *ultimaVerifica;
@property (nonatomic, strong) NSString *ultimoCorso;

@property (nonatomic) BOOL ok;
@property (nonatomic) int codice;
@property (nonatomic) double lastUpdate;
@property (nonatomic) double latitudine;
@property (nonatomic) double longitudine;


@end
