//
//  BNRPhoto.m
//  CountdownToZero
//
//  Created by Christian Keur on 5/1/13.
//  Copyright (c) 2013 Christian Keur. All rights reserved.
//

#import "BNRPhoto.h"

@implementation BNRPhoto

- (id)initWithJSONDictionary: (NSDictionary *)jsonDict
{
    self = [super init];
    
    if (self) {
        [self updateWithJSONDictionary: jsonDict];
        if (!_photoURL)
            return nil;
    }
    
    return self;
}

- (void)updateWithJSONDictionary:(NSDictionary *)jsonDict
{
    if (!jsonDict[@"picture"])
        return;
    
    _photoURL = jsonDict[@"picture"];
    
    if (jsonDict[@"caption"])
        [self setCaption: jsonDict[@"caption"]];
    
    if (jsonDict[@"thumbnail"])
        _thumbnailURL = jsonDict[@"thumbnail"];
}

- (void)setCaption:(NSString *)caption
{
    NSString *newCaption = nil;
    if (caption) {
        newCaption = [caption stringByReplacingOccurrencesOfString: @"<div "
                                                        withString: @"<div style=\"color:white;font-size:10px;font-family:\"Times New Roman\", Times, serif;\" "];
    }
    _caption = newCaption;
}

@end
