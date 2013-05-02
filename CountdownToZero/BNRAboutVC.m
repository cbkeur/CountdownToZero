//
//  BNRAboutVC.m
//  CountdownToZero
//
//  Created by Christian Keur on 5/1/13.
//  Copyright (c) 2013 Christian Keur. All rights reserved.
//

#import "BNRAboutVC.h"

// Views
#import "BNRCarterButton.h"

// Controllers
#import "BNRContactVC.h"

@interface BNRAboutVC () <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *contentView;

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
    
    [_scrollView setContentSize:_contentView.bounds.size];
    [_scrollView addSubview:_contentView];
}

#pragma mark - Actions

- (IBAction)contactUs:(id)sender
{
    BNRContactVC *contactVC = [[BNRContactVC alloc] init];
    [self.navigationController pushViewController:contactVC animated:YES];
}

- (IBAction)donate:(id)sender
{
    // http://donate.cartercenter.org/site/Donation2?df_id=1220&1220.donation=form1
    [[[UIAlertView alloc] initWithTitle:@"Leaving App" message:@"This will exit the app and take you to our website in Mobile Safari. Would you like to continue?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil] show];
}

#pragma mark - Alert view delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == [alertView cancelButtonIndex])
        return;
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://donate.cartercenter.org/site/Donation2?df_id=1220&1220.donation=form1"]];
}

@end
