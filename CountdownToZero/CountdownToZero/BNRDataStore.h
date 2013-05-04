//
//  BNRDataStore.h
//  CountdownToZero
//
//  Created by Christian Keur on 5/1/13.
//  Copyright (c) 2013 Christian Keur. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BNRPhoto;
@class BNRHeadline;

@interface BNRDataStore : NSObject

+ (BNRDataStore *)sharedStore;

// Home
- (void)getHeadlineInfoWithCompletion:(void (^)(BNRHeadline *headline, NSError *err))cBlock;
- (void)getHeadlineImage: (BNRHeadline *)headline WithCompletion: (void (^)(NSData *imageData, NSError *err))cBlock;
- (void)getHistoricalDataWithCompletion:(void (^)(NSArray *data, NSError *err))cBlock;
- (void)getYearToDateNewCaseCountWithCompletion:(void (^)(int count, NSError *err))cBlock;

// Photos
- (void)getPhotoListWithCompletion:(void (^)(NSArray *photos, NSError *err))cBlock;
- (void)getInfographicListWithCompletion:(void (^)(NSArray *infographics, NSError *err))cBlock;
- (void)getPhoto: (BNRPhoto *)photo WithCompletion: (void (^)(NSData *photoData, NSError *err))cBlock;
- (void)getPhotoThumbnail: (BNRPhoto *)photo WithCompletion: (void (^)(NSData *photoData, NSError *err))cBlock;

// Facts
- (void)getFactsWithCompletion:(void (^)(NSArray *facts, NSError *err))cBlock;

@end
