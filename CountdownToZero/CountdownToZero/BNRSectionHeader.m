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
        [self setBackgroundColor: [UIColor carterBlueColor]];
        _sectionNameLabel = [[UILabel alloc] init];
        [_sectionNameLabel setTextColor: [UIColor whiteColor]];
        [_sectionNameLabel setText: @"Test"];
        [_sectionNameLabel setTranslatesAutoresizingMaskIntoConstraints: NO];
        [_sectionNameLabel setBackgroundColor: [UIColor clearColor]];
        UIFont *font = [UIFont fontWithName: @"HoeflerText-Regular" size: 17.0f];
        [_sectionNameLabel setTextAlignment: NSTextAlignmentCenter];
        [_sectionNameLabel setFont: font];
        
        [self addSubview: _sectionNameLabel];
        
        [self addConstraints: [NSLayoutConstraint constraintsWithVisualFormat: @"H:|-5-[a]-5-|"
                                                                      options: NSLayoutFormatAlignAllCenterX
                                                                      metrics: nil
                                                                        views: @{@"a": _sectionNameLabel}]];
        [self addConstraints: [NSLayoutConstraint constraintsWithVisualFormat: @"V:|-7-[a]-5-|"
                                                                      options: NSLayoutFormatAlignAllCenterY
                                                                      metrics: nil
                                                                        views: @{@"a": _sectionNameLabel}]];
    }
    return self;
}

@end
