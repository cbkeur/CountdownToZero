//
//  BNRAboutVC.m
//  CountdownToZero
//
//  Created by Christian Keur on 5/1/13.
//  Copyright (c) 2013 Christian Keur. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

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
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *labelContentView;

@property (nonatomic) float originalImageHeight;

//@property (nonatomic) int currentPictureIndex;
//@property (strong, nonatomic) NSArray *pictureArray;
//@property (strong, nonatomic) NSArray *colorArray;

@end

@implementation BNRAboutVC

#pragma mark - Initializers

- (id)init
{
    self = [super initWithNibName:nil bundle:nil];
    
    if(self)
    {
        [self.navigationItem setTitle:@"About"];
        
//        _pictureArray = @[@"AboutUs.jpg", @"AboutUs2.jpg"];
//        _colorArray = @[[UIColor whiteColor], [UIColor carterRedColor]];
//        _currentPictureIndex = 0;
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
    
    _originalImageHeight = _imageView.bounds.size.height;
    
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
    
//    NSTimer *timer = [NSTimer timerWithTimeInterval:5 target:self selector:@selector(changePicture:) userInfo:nil repeats:YES];
//    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

#pragma mark - Actions

//- (void)changePicture:(NSTimer *)timer
//{
//    _currentPictureIndex = (_currentPictureIndex + 1) % _pictureArray.count;
//
//    UIImage *newImage = [UIImage imageNamed:[_pictureArray objectAtIndex:_currentPictureIndex]];
//    [_imageView setImage:newImage];
//    
//    CATransition *imageAnim = [[CATransition alloc] init];
//    [imageAnim setType:kCATransitionFade];
//    [imageAnim setDuration:0.75];
//    [_imageView.layer addAnimation:imageAnim forKey:nil];
//        
//    UIColor *newColor = [_colorArray objectAtIndex:_currentPictureIndex];
//    UILabel *newLabel = [[UILabel alloc] initWithFrame:_titleLabel.frame];
//    [newLabel setNumberOfLines:_titleLabel.numberOfLines];
//    [newLabel setBackgroundColor:[UIColor clearColor]];
//    [newLabel setText:_titleLabel.text];
//    [newLabel setFont:_titleLabel.font];
//    [newLabel setTextColor:newColor];
//    [newLabel setAlpha:0];
//    [_labelContentView insertSubview:newLabel aboveSubview:_titleLabel];
//    
//    [UIView animateWithDuration:0.75 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
//        [newLabel setAlpha:1];
//        [_titleLabel setAlpha:0];
//    } completion:^(BOOL finished) {
//        [_titleLabel setAlpha:1];
//        [_titleLabel setTextColor:newColor];
//        [newLabel removeFromSuperview];
//    }];
//}

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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(![scrollView isEqual:_scrollView])
        return;
    
    CGPoint contentOffset = _scrollView.contentOffset;
    
    if(contentOffset.y < 0)
    {
        float newHeight = _originalImageHeight + -contentOffset.y;
        
        CGRect frame = _imageView.frame;
        frame.origin.y = contentOffset.y;
        frame.size.height = newHeight;
        
        [_imageView setFrame:frame];
        
        CGPoint center = _titleLabel.center;
        center.y = _imageView.center.y + 7;
        [_titleLabel setCenter:center];
    }
    else
    {
        CGRect frame = _imageView.frame;
        frame.origin.y = 0;
        frame.size.height = _originalImageHeight;
        
        [_imageView setFrame:frame];
        
        CGPoint center = _titleLabel.center;
        center.y = _imageView.center.y + 7;
        [_titleLabel setCenter:center];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(![scrollView isEqual:_principlesScrollView])
        return;
    
    [self handleScrollStop:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(![scrollView isEqual:_principlesScrollView])
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
