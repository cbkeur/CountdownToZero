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
#import "BNRHeadline.h"

@interface BNRHomeVC ()
{
    __weak IBOutlet UIView *_headlineView;
    __weak IBOutlet UIImageView *_headlineImageView;
    __weak IBOutlet UILabel *_headlineLabel;
    
    BNRHeadline *_headline;
    int _count;
}

@property (weak, nonatomic) IBOutlet BNRGuineaGraph *graph;

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
        [[BNRDataStore sharedStore] getYearToDateNewCaseCountWithCompletion: ^(int count, NSError *error) {
            _count = count;
            [_graph growGraph];
            firstLoad = NO;
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
    return 3;
}

- (CGFloat)graph:(BNRGuineaGraph *)graph valueForEntryAtIndex:(int)index
{
    if(index == 0)
        return 150;
    else if(index == 1)
        return 80;
    else
        return _count;
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
