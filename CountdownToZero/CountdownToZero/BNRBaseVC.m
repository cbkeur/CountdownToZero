//
//  BNRBaseVC.m
//  CountdownToZero
//
//  Created by Christian Keur on 5/2/13.
//  Copyright (c) 2013 Christian Keur. All rights reserved.
//

#import "BNRBaseVC.h"

@interface BNRBaseVC ()

@end

@implementation BNRBaseVC

//- (id)init
//{
//    self = [super initWithNibName:nil bundle:nil];
//    
//    return self;
//}
//
//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    return [self init];
//}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.view setBackgroundColor:[UIColor carterBackgroundColor]];
    
    UIImageView *eagleHead = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"eaglehead"]];
    [eagleHead setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleRightMargin];
    [eagleHead setAlpha:0.08];
    [self.view insertSubview:eagleHead atIndex:0];
    [eagleHead setCenter:self.view.center];
}


@end
