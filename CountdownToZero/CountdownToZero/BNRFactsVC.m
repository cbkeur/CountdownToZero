//
//  BNRFactsVC.m
//  CountdownToZero
//
//  Created by Christian Keur on 5/1/13.
//  Copyright (c) 2013 Christian Keur. All rights reserved.
//

#import "BNRFactsVC.h"

// Model
#import "BNRDataStore.h"
#import "BNRFact.h"

// View
#import "BNRFactPage.h"
#import "BNRPageControl.h"

@interface BNRFactsVC () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *infoView;
@property (strong, nonatomic) NSArray *facts;
@property (weak, nonatomic) IBOutlet BNRPageControl *pageControl;

@end

@implementation BNRFactsVC

#pragma mark - Initializers

- (id)init
{
    self = [super initWithNibName:nil bundle:nil];
    
    if(self)
    {
        [self.navigationItem setTitle:@"Facts"];
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
    
    [_scrollView setPagingEnabled:YES];
    [_scrollView addSubview:_infoView];
    [_scrollView setShowsHorizontalScrollIndicator:NO];
    
    [_pageControl setNumberOfPages:0];
    
    [[BNRDataStore sharedStore] getFactsWithCompletion:^(NSArray *facts, NSError *err) {
        _facts = facts;
        
        [_pageControl setNumberOfPages:(_facts.count + 1)];
        [_pageControl setCurrentPage:0];
        
        [self layoutScrollView];
    }];
}

#pragma mark - Table view methods

- (void)layoutScrollView
{
    CGRect frame = _scrollView.bounds;
    
    for(int i = 1; i <= _facts.count; i++)
    {
        frame.origin.x = frame.size.width * i;
        BNRFactPage *page = [[BNRFactPage alloc] initWithFrame:frame];
        [_scrollView addSubview:page];
        
        BNRFact *fact = [_facts objectAtIndex:(i-1)];
        [page setQuestionText:fact.question];
        [page setAnswerTextWithHTML:fact.answer];
    }
    
    CGSize size = _scrollView.bounds.size;
    size.width *= (_facts.count + 1);
    [_scrollView setContentSize:size];
}

#pragma mark - Scroll view methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(![scrollView isEqual:_scrollView])
        return;
    
    [self handleScrollStop:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(![scrollView isEqual:_scrollView])
        return;
    
    if(!decelerate)
        [self handleScrollStop:scrollView];
}

- (void)handleScrollStop:(UIScrollView *)sv
{
    int page = sv.contentOffset.x / sv.bounds.size.width;
    [_pageControl setCurrentPage:page];
}

@end
