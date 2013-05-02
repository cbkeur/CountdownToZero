//
//  BNRDataStore.h
//  CountdownToZero
//
//  Created by Christian Keur on 5/1/13.
//  Copyright (c) 2013 Christian Keur. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BNRPhoto;

@interface BNRDataStore : NSObject

+ (BNRDataStore *)sharedStore;

// Home
- (void)getHeadlineInfoWithCompletion:(void (^)(id obj, NSError *err))cBlock;
- (void)getYearToDateNewCaseCountWithCompletion:(void (^)(int count, NSError *err))cBlock;

// Photos
- (void)getPhotoListWithCompletion:(void (^)(NSArray *photos, NSError *err))cBlock;
- (void)getPhoto: (BNRPhoto *)photo WithCompletion: (void (^)(NSData *photoData, NSError *err))cBlock;

// Facts
- (void)getFactsWithCompletion:(void (^)(NSArray *facts, NSError *err))cBlock;

@end
