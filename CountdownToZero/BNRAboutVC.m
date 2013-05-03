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
#import "BNRPageControl.h"

// Controllers
#import "BNRContactVC.h"

@interface BNRAboutVC () <UIAlertViewDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIScrollView *principlesScrollView;
@property (weak, nonatomic) IBOutlet BNRPageControl *pageControl;

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
    
    NSArray *principles = @[@"The Center emphasizes action and results. Based on careful research and analysis, it is prepared to take timely action on important and pressing issues.", @"The Center does not duplicate the effective efforts of others.", @"The Center addresses difficult problems and recognizes the possibility of failure as an acceptable risk.", @"The Center is nonpartisan and acts as a neutral in dispute resolution activities.", @"The Center believes that people can improve their lives when provided with the necessary skills, knowledge, and access to resources."];
    
    for(int i = 0; i < principles.count; i++)
    {
        CGRect frame = _principlesScrollView.bounds;
        frame.origin.x = _principlesScrollView.bounds.size.width * i;
        frame.origin.x += 10;
        frame.size.width -= 20;
        frame.origin.y += 10;
        frame.size.height -= 20;
        
        UILabel *l = [[UILabel alloc] initWithFrame:frame];
        [l setBackgroundColor:[UIColor clearColor]];
        [l setNumberOfLines:0];
        [l setTextAlignment:NSTextAlignmentCenter];
        [l setText:[principles objectAtIndex:i]];
        
        [_principlesScrollView addSubview:l];
    }
    
    [_principlesScrollView setPagingEnabled:YES];
    [_principlesScrollView setShowsHorizontalScrollIndicator:NO];
    [_principlesScrollView setContentSize:CGSizeMake(_principlesScrollView.bounds.size.width * 5, _principlesScrollView.bounds.size.height)];
    [_pageControl setNumberOfPages:5];
    [_pageControl setCurrentPage:0];
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

#pragma mark - Scroll view methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self handleScrollStop:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(!decelerate)
        [self handleScrollStop:scrollView];
}

- (void)handleScrollStop:(UIScrollView *)sv
{
    int page = sv.contentOffset.x / sv.bounds.size.width;
    [_pageControl setCurrentPage:page];
}

@end
