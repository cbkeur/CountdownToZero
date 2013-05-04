//
//  BNRSectionHeader.m
//  CountdownToZero
//
//  Created by Thomas Ward on 5/3/13.
//  Copyright (c) 2013 Christian Keur. All rights reserved.
//

#import "BNRSectionHeader.h"

@implementation BNRSectionHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor: [UIColor blackColor]];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
