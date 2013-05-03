//
//  BNRViewController.m
//  TableView
//
//  Created by Christian Keur on 5/3/13.
//  Copyright (c) 2013 Christian Keur. All rights reserved.
//

#import "BNRViewController.h"

@interface BNRViewController ()

@property (nonatomic, strong) NSArray *names;

@end

@implementation BNRViewController

- (void)viewDidLoad
{
    _names = @[@"Alice", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _names.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITVC"];
    if(!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITVC"];
    
    NSLog(@"%@", [_names objectAtIndex:indexPath.row]);
    [[cell textLabel] setText:[_names objectAtIndex:indexPath.row]];
    
    return cell;
}

@end
