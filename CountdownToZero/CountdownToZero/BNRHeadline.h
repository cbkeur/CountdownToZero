//
//  BNRHeadline.h
//  CountdownToZero
//
//  Created by Thomas Ward on 5/4/13.
//  Copyright (c) 2013 Christian Keur. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNRHeadline : NSObject

@property (nonatomic) NSString *headline;
@property (nonatomic) NSString *imageURL;
@property (nonatomic) NSString *headlineLink;
@property (nonatomic) UIImage *headlineImage;

- (id)initWithJSONDictionary: (NSDictionary *)jsonDict;

- (void)updateWithJSONDictionary: (NSDictionary *)jsonDict;

@end
