//
//  DetailViewController.h
//  myVita
//
//  Created by Marco Velluto on 27/03/13.
//  Copyright (c) 2013 Algos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UITableViewController {
    
    NSMutableArray *arrayInfo; //Contiene i valori (es. 20090 ect.)
    NSMutableArray *arrayNameInfo; //Contiene i nomi dei valori (es. Cap etc.)
    NSMutableArray *arrayValueTV; //Contiene i due array precedenti.
}


@end
