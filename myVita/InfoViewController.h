//
//  InfoViewController.h
//  myVita
//
//  Created by Marco Velluto on 27/03/13.
//  Copyright (c) 2013 Algos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoViewController : UITableViewController {
    
    NSMutableArray *arrayDefibrillatori;
    NSMutableArray *arrayDefibrillatoriToView;
    NSMutableArray *arraySort;
}
@property (retain, nonatomic) IBOutlet UIBarButtonItem *buttonSelect;

- (IBAction)pressButtonSelect:(id)sender;
- (IBAction)pressButtonRefresh:(id)sender;
@end
