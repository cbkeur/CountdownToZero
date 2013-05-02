//
//  BNRHomeVC.m
//  CountdownToZero
//
//  Created by Christian Keur on 5/1/13.
//  Copyright (c) 2013 Christian Keur. All rights reserved.
//

#import "BNRHomeVC.h"

// View
#import "BNRCountdownView.h"

// Controller
#import "BNRHeadlineVC.h"

@interface BNRHomeVC ()

@property (weak, nonatomic) IBOutlet BNRCountdownView *countdownView;

@end

@implementation BNRHomeVC

#pragma mark - Initializers

- (id)init
{
    self = [super initWithNibName:nil bundle:nil];

    if(self)
    {
        UIImageView *titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon"]];
        [self.navigationItem setTitleView:titleView];
//        [self.navigationItem setTitle:@"Countdown To Zero"];
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self init];
}

#pragma mark - View methods

- (void)viewDidLoad
{
    [super viewDidLoad];

    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    static BOOL firstLoad = YES;
    if(firstLoad)
    {
        [_countdownView countdownFrom:10000 to:6 duration:1 completion:nil];
        firstLoad = NO;
    }
}

#pragma mark - Actions

- (IBAction)headlineTapped:(id)sender
{
    BNRHeadlineVC *headlineVC = [[BNRHeadlineVC alloc] init];
    [self.navigationController pushViewController:headlineVC animated:YES];
}

@end
