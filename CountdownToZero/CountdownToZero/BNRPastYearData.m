//
//  BNRPastYearData.m
//  CountdownToZero
//
//  Created by Christian Keur on 5/4/13.
//  Copyright (c) 2013 Christian Keur. All rights reserved.
//

#import "BNRPastYearData.h"

@interface BNRPastYearData ()

@property (strong, nonatomic) NSDictionary *casesPerMonth;

@end

@implementation BNRPastYearData

- (id)initWithAttributes:(NSDictionary *)attrs
{
    self = [super init];
    
    if(self)
    {
        if([attrs objectForKey:@"year"])
            _year = [attrs objectForKey:@"year"];
        
        if([attrs objectForKey:@"total_cases"])
            _totalCasesForYear = [attrs objectForKey:@"total_cases"];
        
        if([attrs objectForKey:@"months"])
            _casesPerMonth = [attrs objectForKey:@"months"];
    }
    
    return self;
}

- (int)casesThroughCurrentDayInPastYear
{
    NSDateComponents *comps = [[NSCalendar currentCalendar] components:NSMonthCalendarUnit fromDate:[NSDate date]];
    int currentMonth = [comps month];
    
    int count = 0;
    for(NSDictionary *month in _casesPerMonth)
    {
        if([month objectForKey:@"month"])
        {
            if([[month objectForKey:@"month"] intValue] < currentMonth &&
               [month objectForKey:@"cases"])
                count += [[month objectForKey:@"cases"] intValue];
            else
                break;
        }
    }
    
    return count;
}

@end
