//
//  BNRFactPage.m
//  CountdownToZero
//
//  Created by Christian Keur on 5/2/13.
//  Copyright (c) 2013 Christian Keur. All rights reserved.
//

#import "BNRFactPage.h"

@interface BNRFactPage ()

@property (weak, nonatomic) UILabel *questionLabel;
@property (weak, nonatomic) UIWebView *webView;

@end

@implementation BNRFactPage

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        CGRect labelFrame = CGRectMake(20, 20, frame.size.width - 40, 50);
        UILabel *questionLabel = [[UILabel alloc] initWithFrame:labelFrame];
        [questionLabel setNumberOfLines:0];
        [questionLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:questionLabel];
        
        _questionLabel = questionLabel;
        
        
        CGRect webFrame = CGRectMake(20, 80, frame.size.width - 40, frame.size.height - 50 - 20 - 10);
        UIWebView *webView = [[UIWebView alloc] initWithFrame:webFrame];
        [webView setBackgroundColor:[UIColor clearColor]];
        [webView setOpaque:NO];
        if ([[webView subviews] count] > 0)
        {
            for (UIView* shadowView in [[[webView subviews] objectAtIndex:0] subviews])
            {
                [shadowView setHidden:YES];
            }
            
            // Unhide the last view so it is visible again because it has the content
            [[[[[webView subviews] objectAtIndex:0] subviews] lastObject] setHidden:NO];
        }
        [self addSubview:webView];
        
        _webView = webView;
    }
    
    return self;
}

- (void)setQuestionText:(NSString *)str
{
    [_questionLabel setText:str];
}

- (void)setAnswerTextWithHTML:(NSString *)str
{
    [_webView loadHTMLString:str baseURL:nil];
}

@end
