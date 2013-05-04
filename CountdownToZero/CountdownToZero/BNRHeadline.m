//
//  BNRHeadline.m
//  CountdownToZero
//
//  Created by Thomas Ward on 5/4/13.
//  Copyright (c) 2013 Christian Keur. All rights reserved.
//

#import "BNRHeadline.h"

@implementation BNRHeadline
- (id)initWithJSONDictionary: (NSDictionary *)jsonDict
{
    self = [super init];
    
    if (self) {
        [self updateWithJSONDictionary: jsonDict];
    }
    
    return self;
}

- (void)updateWithJSONDictionary: (NSDictionary *)jsonDict
{
    if (jsonDict[@"caption"])
        _headline = jsonDict[@"caption"];
    
    if (jsonDict[@"picture"])
        _imageURL = jsonDict[@"picture"];
    
    if (jsonDict[@"link"])
        _headlineLink = jsonDict[@"link"];
}

@end
