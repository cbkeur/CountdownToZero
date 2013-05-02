//
//  BNRFactCell.m
//  CountdownToZero
//
//  Created by Christian Keur on 5/2/13.
//  Copyright (c) 2013 Christian Keur. All rights reserved.
//

#import "BNRFactCell.h"

@interface BNRFactCell ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation BNRFactCell

- (void)cellDidLoad
{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
}

- (void)setFactText:(NSString *)str
{
    [_webView loadHTMLString:str baseURL:nil];
}


+ (UIFont *)font
{
    return [UIFont systemFontOfSize:18];
}

+ (float)heightForCellWithString:(NSString *)str
{
    float padding = 41;
    CGSize size = [str sizeWithFont:[self font] constrainedToSize:CGSizeMake(264, 10000)];
    
    return padding + size.height - 40;
}

@end
