//
//  ProvaViewController.m
//  myVita
//
//  Created by Marco Velluto on 04/04/13.
//  Copyright (c) 2013 Algos. All rights reserved.
//

#import "ProvaViewController.h"

@interface ProvaViewController ()

@end

@implementation ProvaViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_o release];
    [super dealloc];
}
@end
