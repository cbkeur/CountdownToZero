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
#import "BNRFactCell.h"

@interface BNRFactsVC () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
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
    
    [[BNRDataStore sharedStore] getFactsWithCompletion:^(NSArray *facts, NSError *err) {
        _facts = facts;
        [_tableView reloadData];
    }];
}

#pragma mark - Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_facts count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    BNRFact *theFact = [_facts objectAtIndex:section];
    
    CGRect frame = CGRectMake(0, 0, tableView.frame.size.width, 75);
    UIView *view = [[UIView alloc] initWithFrame:frame];
    [view setBackgroundColor:[UIColor yellowColor]];
    
    UILabel *question = [[UILabel alloc] initWithFrame:frame];
    [question setNumberOfLines:0];
    [question setText:theFact.question];
    [view addSubview:question];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 75;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BNRFactCell *cell = [BNRFactCell cellForTableView:tableView target:self configure:nil];
    
    BNRFact *theFact = [_facts objectAtIndex:indexPath.section];
//    [[cell factLabel] setText:theFact.answer];
    [cell setFactText:theFact.answer];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BNRFact *theFact = [_facts objectAtIndex:indexPath.section];
    
    return [BNRFactCell heightForCellWithString:theFact.answer];
}

@end
