//
//  BNRCarterCenter.h
//  CountdownToZero
//
//  Created by Christian Keur on 5/2/13.
//  Copyright (c) 2013 Christian Keur. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface BNRCarterCenter : NSObject

+ (id)theCenter;

@property (copy, nonatomic) NSString *title;
@property (nonatomic) CLLocationCoordinate2D coordinate;

@end
