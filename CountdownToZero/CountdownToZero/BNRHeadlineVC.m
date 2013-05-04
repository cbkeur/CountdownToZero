//
//  BNRHeadlineVC.m
//  CountdownToZero
//
//  Created by Christian Keur on 5/1/13.
//  Copyright (c) 2013 Christian Keur. All rights reserved.
//

#import "BNRHeadlineVC.h"
#import "BNRHeadline.h"

@interface BNRHeadlineVC ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) BNRHeadline *headline;

@end

@implementation BNRHeadlineVC

#pragma mark - Initializers

- (id)initWithHeadline: (BNRHeadline *)headline;
{
    self = [super initWithNibName:nil bundle:nil];
    
    if(self)
    {
//        UIBarButtonItem *safariBtn = [[UIBarButtonItem alloc] initWithTitle:@"Open in Safari" style:UIBarButtonItemStyleBordered target:self action:@selector(openInSafari:)];
//        [self.navigationItem setRightBarButtonItem:safariBtn];        
        
        [self.navigationItem setTitle:@"Headline"];
        _headline = headline;
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self initWithHeadline: nil];
}

#pragma mark - View methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [_webView setScalesPageToFit:YES];
    
    NSURL *url = [NSURL URLWithString:[_headline headlineLink]];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:req];
}

#pragma mark - Action

- (void)openInSafari:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_headline.headlineLink]];
}

@end
