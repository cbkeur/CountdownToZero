//
//  BNRAboutVC.m
//  CountdownToZero
//
//  Created by Christian Keur on 5/1/13.
//  Copyright (c) 2013 Christian Keur. All rights reserved.
//

#import "BNRAboutVC.h"

// Controllers
#import "BNRContactVC.h"

@interface BNRAboutVC ()

@end

@implementation BNRAboutVC

#pragma mark - Initializers

- (id)init
{
    self = [super initWithNibName:nil bundle:nil];
    
    if(self)
    {
        [self.navigationItem setTitle:@"About"];
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - Actions

- (IBAction)contactUs:(id)sender
{
    BNRContactVC *contactVC = [[BNRContactVC alloc] init];
    [self.navigationController pushViewController:contactVC animated:YES];
}

@end
