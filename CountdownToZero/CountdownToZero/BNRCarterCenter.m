//
//  BNRCarterCenter.m
//  CountdownToZero
//
//  Created by Christian Keur on 5/2/13.
//  Copyright (c) 2013 Christian Keur. All rights reserved.
//

#import "BNRCarterCenter.h"

@implementation BNRCarterCenter

+ (id)theCenter
{
    static BNRCarterCenter *carterCenter = nil;
    static dispatch_once_t OnceToken;
    dispatch_once(&OnceToken, ^{
        carterCenter = [[BNRCarterCenter alloc] init];
    });
    return carterCenter;
}

- (NSString *)title
{
    return @"The Carter Center";
}

- (CLLocationCoordinate2D)coordinate
{
    return CLLocationCoordinate2DMake(33.766784, -84.354877);
}

@end
