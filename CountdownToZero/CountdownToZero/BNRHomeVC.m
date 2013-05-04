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
#import "BNRGuineaGraph.h"

// Controller
#import "BNRHeadlineVC.h"
#import "BNRDataStore.h"

@interface BNRHomeVC ()
{
    int _count;
}

@property (weak, nonatomic) IBOutlet BNRGuineaGraph *graph;

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
        [self.navigationItem setTitle:@"Countdown to Zero"];
        
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
    //    if(firstLoad)
    //    {
    firstLoad = NO;
    [_graph growGraph];
    //    }
    /*
    if(firstLoad)
    {
        //[_countdownView countdownFrom:10000 to: _count duration:1 completion:nil];
        //firstLoad = NO;
        
        
        [[BNRDataStore sharedStore] getYearToDateNewCaseCountWithCompletion: ^(int count, NSError *error) {
            _count = count;
            [_countdownView countdownFrom:10000 to: _count duration:1 completion:nil];
            firstLoad = NO;
        }];
     
    }*/
    
    
}

#pragma mark - Actions

- (IBAction)headlineTapped:(id)sender
{
    BNRHeadlineVC *headlineVC = [[BNRHeadlineVC alloc] init];
    [self.navigationController pushViewController:headlineVC animated:YES];
}

#pragma mark - Graph data source methods

- (int)numberOfEntriesInGraph:(BNRGuineaGraph *)graph
{
    return 3;
}

- (CGFloat)graph:(BNRGuineaGraph *)graph valueForEntryAtIndex:(int)index
{
    if(index == 0)
        return 150;
    else if(index == 1)
        return 80;
    else
        return 15;
}

- (NSString *)graph:(BNRGuineaGraph *)graph titleForEntryAtIndex:(int)index
{
    if(index == 0)
        return @"2011";
    else if(index == 1)
        return @"2012";
    else
        return @"2013";
}

@end
