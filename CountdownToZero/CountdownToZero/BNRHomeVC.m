//
//  BNRHomeVC.m
//  CountdownToZero
//
//  Created by Christian Keur on 5/1/13.
//  Copyright (c) 2013 Christian Keur. All rights reserved.
//

#import "BNRHomeVC.h"

// Model
#import "BNRPastYearData.h"

// View
#import "BNRCountdownView.h"
#import "BNRGuineaGraph.h"

// Controller
#import "BNRHeadlineVC.h"
#import "BNRDataStore.h"
#import "BNRHeadline.h"

@interface BNRHomeVC ()
{
    __weak IBOutlet UIView *_headlineView;
    __weak IBOutlet UIImageView *_headlineImageView;
    __weak IBOutlet UILabel *_headlineLabel;
    __weak IBOutlet UILabel *_casesLabel;
    
    BNRHeadline *_headline;
    int _count;
    BOOL _dataLoaded;
    BOOL _viewAppeared;
}

@property (weak, nonatomic) IBOutlet BNRGuineaGraph *graph;
@property (strong, nonatomic) NSArray *historicalData;

- (void)configureHeadline;

@end

@implementation BNRHomeVC

#pragma mark - Initializers

- (id)init
{
    self = [super initWithNibName:nil bundle:nil];

    if(self)
    {
        [self.navigationItem setTitle:@"Countdown to Zero"];
        
        UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:@"Countdown" style:UIBarButtonItemStyleBordered target:nil action:nil];
        [self.navigationItem setBackBarButtonItem:backBtn];
        
        _viewAppeared = NO;
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
    
    NSDate *now = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setTimeStyle:NSDateFormatterNoStyle];
    [df setDateStyle:NSDateFormatterShortStyle];
    NSString *labelStr = [NSString stringWithFormat:@"Worldwide Cases\nJanuary 1 - %@", [df stringFromDate:now]];
    [_casesLabel setText:labelStr];
    [_casesLabel setHidden:YES];
    
    __block int counter = 0;
    void (^finalBlock)(void) = ^{
        counter--;
        if(counter == 0)
        {
            _dataLoaded = YES;
            [_casesLabel setHidden:NO];
            [_graph growGraph];
        }
    };
    
    counter++;
    [[BNRDataStore sharedStore] getHistoricalDataWithCompletion:^(NSArray *data, NSError *err) {
        
        if(data.count > 2)
        {
            NSMutableArray *dataCopy = [NSMutableArray array];
            for(int i = data.count - 2; i < data.count; i++)
                [dataCopy addObject:[data objectAtIndex:i]];
            _historicalData = [dataCopy copy];
        }
        else
        {
            _historicalData = data;
        }
        
        finalBlock();
    }];
    
    counter++;
    [[BNRDataStore sharedStore] getYearToDateNewCaseCountWithCompletion: ^(int count, NSError *error) {
        _count = count;

        finalBlock();
    }];
    
    [[BNRDataStore sharedStore] getHeadlineInfoWithCompletion: ^(BNRHeadline *headline, NSError *error) {
        _headline = headline;
        [self configureHeadline];
        [[BNRDataStore sharedStore] getHeadlineImage: headline WithCompletion: ^(NSData *imageData, NSError *err) {
            if (imageData) {
                //[activityIndicatorView stopAnimating];
                UIImage *image = [UIImage imageWithData: imageData];
                if (image) {
                    [headline setHeadlineImage: image];
                    [self configureHeadline];
                    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget: self
                                                                                                 action:@selector(headlineTapped:)];
                    [_headlineView addGestureRecognizer: tapGesture];
                }
            }
        }];
    }];
}

#pragma mark - Actions

- (void)headlineTapped:(id)sender
{
    BNRHeadlineVC *headlineVC = [[BNRHeadlineVC alloc] init];
    [self.navigationController pushViewController:headlineVC animated:YES];
}

- (void)configureHeadline
{
    [_headlineLabel setText: [_headline headline]];
    [_headlineLabel setTextColor: [UIColor whiteColor]];
    
    if ([_headline headlineImage])
        [_headlineImageView setImage: [_headline headlineImage]];
}

#pragma mark - Graph data source methods

- (int)numberOfEntriesInGraph:(BNRGuineaGraph *)graph
{
    if(!_dataLoaded)
        return 0;
    return 1 + [_historicalData count];
}

- (CGFloat)graph:(BNRGuineaGraph *)graph valueForEntryAtIndex:(int)index
{
    if(index < _historicalData.count)
        return [[_historicalData objectAtIndex:index] casesThroughCurrentDayInPastYear];
    else
        return _count;
    
    
//    if(index == 0)
//        return 382; // 382
//    else if(index == 1)
//        return 142; // 142
//    else
//        return _count;
}

- (NSString *)graph:(BNRGuineaGraph *)graph titleForEntryAtIndex:(int)index
{
    if(index < _historicalData.count)
        return [(BNRPastYearData *)[_historicalData objectAtIndex:index] year];
    else
        return @"2013";
    
//    if(index == 0)
//        return @"2011";
//    else if(index == 1)
//        return @"2012";
//    else
//        return @"2013";
}

@end
