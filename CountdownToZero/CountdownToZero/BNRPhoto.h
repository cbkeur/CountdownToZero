//
//  BNRPhoto.h
//  CountdownToZero
//
//  Created by Christian Keur on 5/1/13.
//  Copyright (c) 2013 Christian Keur. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNRPhoto : NSObject

@property (copy, nonatomic) NSString *photoURL;
@property (copy, nonatomic) NSString *caption;
@property (copy, nonatomic) NSString *thumbnailURL;
@property (copy, nonatomic) UIImage *thumbnail;
@property (nonatomic, strong) UIImage *photo;

- (id)initWithJSONDictionary: (NSDictionary *)jsonDict;

- (void)updateWithJSONDictionary: (NSDictionary *)jsonDict;

@end
