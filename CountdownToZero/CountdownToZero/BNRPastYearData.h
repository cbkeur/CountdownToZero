//
//  BNRPastYearData.h
//  CountdownToZero
//
//  Created by Christian Keur on 5/4/13.
//  Copyright (c) 2013 Christian Keur. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNRPastYearData : NSObject

@property (copy, nonatomic) NSString *year;
@property (copy, nonatomic) NSString *totalCasesForYear;

- (id)initWithAttributes:(NSDictionary *)attrs;
- (int)casesThroughCurrentDayInPastYear;

@end
