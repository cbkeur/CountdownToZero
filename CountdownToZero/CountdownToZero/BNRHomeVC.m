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
#import "BNRDataStore.h"

@interface BNRHomeVC ()
{
    int _count;
}

@property (weak, nonatomic) IBOutlet BNRCountdownView *countdownView;

@end

@implementation BNRHomeVC

#pragma mark - Initializers

- (id)init
{
    self = [super initWithNibName:nil bundle:nil];

    if(self)
    {
//        UIImageView *titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"head"]];
//        [self.navigationItem setTitleView:titleView];
        [self.navigationItem setTitle:@"Guinea Worm"];
        
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self init];
}

#pragma mark - View methods

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    static BOOL firstLoad = YES;
    if(firstLoad)
    {
        //[_countdownView countdownFrom:10000 to: _count duration:1 completion:nil];
        //firstLoad = NO;
        
        [[BNRDataStore sharedStore] getYearToDateNewCaseCountWithCompletion: ^(int count, NSError *error) {
            _count = count;
            [_countdownView countdownFrom:10000 to: _count duration:1 completion:nil];
            firstLoad = NO;
        }];
    }
    
    
}

#pragma mark - Actions

- (IBAction)headlineTapped:(id)sender
{
    BNRHeadlineVC *headlineVC = [[BNRHeadlineVC alloc] init];
    [self.navigationController pushViewController:headlineVC animated:YES];
}

@end
