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
{
    BNRHeadline *_headline;
}

@end

@implementation BNRHeadlineVC

#pragma mark - Initializers

- (id)initWithHeadline: (BNRHeadline *)headline;
{
    self = [super initWithNibName:nil bundle:nil];
    
    if(self)
    {
        [self.navigationItem setTitle:@"Headline"];
        _headline = headline;
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self initWithHeadline: nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
