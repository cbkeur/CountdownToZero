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

@interface BNRFactsVC () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *infoView;
@property (strong, nonatomic) NSArray *facts;

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
    
    [[BNRDataStore sharedStore] getFactsWithCompletion:^(NSArray *facts, NSError *err) {
        _facts = facts;
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

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return [_facts count];
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    BNRFact *theFact = [_facts objectAtIndex:section];
//    
//    CGRect frame = CGRectMake(0, 0, tableView.frame.size.width, 75);
//    UIView *view = [[UIView alloc] initWithFrame:frame];
//    [view setBackgroundColor:[UIColor yellowColor]];
//    
//    UILabel *question = [[UILabel alloc] initWithFrame:frame];
//    [question setNumberOfLines:0];
//    [question setText:theFact.question];
//    [view addSubview:question];
//    
//    return view;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 75;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return 1;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    BNRFactCell *cell = [BNRFactCell cellForTableView:tableView target:self configure:nil];
//    
//    BNRFact *theFact = [_facts objectAtIndex:indexPath.section];
////    [[cell factLabel] setText:theFact.answer];
//    [cell setFactText:theFact.answer];
//    
//    return cell;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    BNRFact *theFact = [_facts objectAtIndex:indexPath.section];
//    
//    return [BNRFactCell heightForCellWithString:theFact.answer];
//}

@end
