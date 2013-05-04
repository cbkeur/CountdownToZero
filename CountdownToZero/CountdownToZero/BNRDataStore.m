//
//  BNRDataStore.m
//  CountdownToZero
//
//  Created by Christian Keur on 5/1/13.
//  Copyright (c) 2013 Christian Keur. All rights reserved.
//

//#define DUMMY_DATA

#import "BNRDataStore.h"

// Model
#import "BNRPhoto.h"
#import "BNRFact.h"
#import "BNRHeadline.h"
#import "BNRPastYearData.h"

// Web services
#import "BNRConnection.h"

@implementation BNRDataStore

#pragma mark - Singleton

+ (BNRDataStore *)sharedStore
{
    static BNRDataStore *sharedStore = nil;
    static dispatch_once_t OnceToken;
    dispatch_once(&OnceToken, ^{
        sharedStore = [[BNRDataStore alloc] init];
    });
    return sharedStore;
}

// headline (text and photo url)
// number of cases this calendar year

#pragma mark - Home page calls

- (void)getHeadlineInfoWithCompletion:(void (^)(BNRHeadline *headline, NSError *err))cBlock
{
#ifdef DUMMY_DATA
    id data = nil;
    NSError *error = nil;
    data = @{@"title": @"Chad eliminated all cases of guinea worm", @"url" : @"www.google.com"};
    if(cBlock)
        cBlock(data, error);
#else
    [BNRConnection connectionWithURLString: @"http://guinea-worm.herokuapp.com/headlines.json"
                          startImmediately: YES
                           completionBlock: ^(id jsonObj, NSError *err) {
                               BNRHeadline *headline = nil;
                               if ([jsonObj isKindOfClass: [NSDictionary class]]) {
                                   headline = [[BNRHeadline alloc] initWithJSONDictionary: jsonObj];
                               }
                               
                               if(cBlock)
                                   cBlock(headline, err);
                           }];
#endif
}

- (void)getHeadlineImage: (BNRHeadline *)headline WithCompletion: (void (^)(NSData *imageData, NSError *err))cBlock
{
    if (![headline imageURL])
    {
        if(cBlock)
            cBlock(nil, [NSError errorWithDomain:@"com.bignerdranch.guinea" code:-1 userInfo:nil]);
        return;
    }
    
    [BNRConnection connectionWithURLString: [headline imageURL] startImmediately: YES completionBlock: cBlock];
}

- (void)getHistoricalDataWithCompletion:(void (^)(NSArray *data, NSError *err))cBlock
{
    [BNRConnection connectionWithURLString: @"http://guinea-worm.herokuapp.com/past_years.json"
                          startImmediately:YES
                           completionBlock:^(id obj, NSError *err) {
                               
                               NSMutableArray *monthData = [NSMutableArray array];
                               for(NSDictionary *d in obj)
                               {
                                   BNRPastYearData *historicalData = [[BNRPastYearData alloc] initWithAttributes:d];
                                   [monthData addObject:historicalData];
                               }
                               
                               NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"year" ascending:YES];
                               [monthData sortUsingDescriptors:@[sd]];
                               
                               if(cBlock)
                                   cBlock([monthData copy], err);
    }];
}

- (void)getYearToDateNewCaseCountWithCompletion:(void (^)(int count, NSError *err))cBlock
{
    NSError *error = nil;
#ifdef DUMMY_DATA
    int count = 0;
    count = 6;
    
    if(cBlock)
        cBlock(count, error);
#else
    [BNRConnection connectionWithURLString: @"http://guinea-worm.herokuapp.com/countdowns.json"
                          startImmediately: YES
                           completionBlock: ^(id jsonObj, NSError *err) {
                               int count = 0;
                               if ([jsonObj isKindOfClass: [NSDictionary class]]) {
                                   if (jsonObj[@"total_cases"] && [jsonObj[@"total_cases"] isKindOfClass: [NSString class]]) {
                                       count = [(NSString *)jsonObj[@"total_cases"] integerValue];
                                   }
                               }
                               
                               if(cBlock)
                                   cBlock(count, error);
                           }];
#endif
}

#pragma mark - Photos

- (void)getPhotoListWithCompletion:(void (^)(NSArray *photos, NSError *err))cBlock
{
#ifdef DUMMY_DATA
    NSMutableArray *photos = nil;
    NSError *error = nil;

    NSData *jsonData = [NSData dataWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"photos" ofType: @"json"]];
    id jsonObj = [NSJSONSerialization JSONObjectWithData: jsonData options: NSJSONReadingAllowFragments error: &error];
    
    if ([jsonObj isKindOfClass: [NSArray class]]) {
        photos = [NSMutableArray array];
        for (NSDictionary *jsonDict in jsonObj) {
            BNRPhoto *photo = [[BNRPhoto alloc] initWithJSONDictionary: jsonDict];
            
            if (photo) {
                [photos addObject: photo];
            }
        }
    }
    
    if(cBlock)
        cBlock(photos, error);
#else
    [BNRConnection connectionWithURLString: @"http://guinea-worm.herokuapp.com/pictures.json"
                          startImmediately: YES
                           completionBlock: ^(id jsonObj, NSError *err) {
                               NSMutableArray *photos = [NSMutableArray array];
                               if ([jsonObj isKindOfClass: [NSArray class]]) {
                                   for (NSDictionary *jsonDict in jsonObj) {
                                       BNRPhoto *photo = [[BNRPhoto alloc] initWithJSONDictionary: jsonDict];
                                       
                                       if (photo) {
                                           [photos addObject: photo];
                                       }
                                   }
                               }
                               
                               if(cBlock)
                                   cBlock(photos, err);
                           }];
#endif

}

- (void)getInfographicListWithCompletion:(void (^)(NSArray *infographics, NSError *err))cBlock
{
    [BNRConnection connectionWithURLString: @"http://guinea-worm.herokuapp.com/infographics.json"
                          startImmediately: YES
                           completionBlock: ^(id jsonObj, NSError *err) {
                               NSMutableArray *infoGraphics = [NSMutableArray array];
                               if ([jsonObj isKindOfClass: [NSArray class]]) {
                                   for (NSDictionary *jsonDict in jsonObj) {
                                       BNRPhoto *infographic = [[BNRPhoto alloc] initWithJSONDictionary: jsonDict];
                                       
                                       if (infographic) {
                                           [infoGraphics addObject: infographic];
                                       }
                                   }
                               }
                               
                               if(cBlock)
                                   cBlock(infoGraphics, err);
                           }];
}


- (void)getPhoto: (BNRPhoto *)photo WithCompletion: (void (^)(NSData *photoData, NSError *err))cBlock
{
    if (![photo photoURL])
        return;
    
    [BNRConnection connectionWithURLString: [photo photoURL] startImmediately: YES completionBlock: cBlock];
}

- (void)getPhotoThumbnail: (BNRPhoto *)photo WithCompletion: (void (^)(NSData *photoData, NSError *err))cBlock
{
    if (![photo thumbnailURL])
        return;
    
    [BNRConnection connectionWithURLString: [photo thumbnailURL] startImmediately: YES completionBlock: cBlock];
}

#pragma mark - Facts

- (void)getFactsWithCompletion:(void (^)(NSArray *facts, NSError *err))cBlock
{
#ifdef DUMMY_DATA
    NSMutableArray *facts = nil;
    NSError *error = nil;
    
    facts = [NSMutableArray array];
    BNRFact *fact = [[BNRFact alloc] init];
    [fact setQuestion:@"What is Guinea worm disease?"];
    [fact setAnswer:@"Guinea worm disease, also known as dracunculiasis, is a parasitic infection caused by the nematode roundworm parasite Dracunculus medenisis."];
    [facts addObject:fact];
    
    fact = [[BNRFact alloc] init];
    [fact setQuestion:@"How do you get Guinea worm disease?"];
    [fact setAnswer:@"Guinea worm disease is contracted when people ingest drinking water from stagnant sources containing copepods (commonly referred to as water fleas) that harbor infective Guinea worm larvae. Inside a human's abdomen, Guinea worm larvae mate and female worms mature and grow, some as long as 3 feet (1 meter). After a year of incubation, the female Guinea worm creates an agonizingly painful lesion on the skin and slowly emerges from the body. The contamination cycle begins when victims, seeking relief from the burning sensation caused by the emerging Guinea worm, immerse their limbs in sources of drinking water, which stimulates the emerging worm to release larvae into the water and begin the cycle all over again."];
    [facts addObject:fact];
    
    fact = [[BNRFact alloc] init];
    [fact setQuestion:@"How widespread is the problem?"];
    [fact setAnswer:@"In 1986, the disease afflicted an estimated 3.5 million people a year in 21 countries in Africa and Asia. Today, thanks to the work of The Carter Center and its partners—including the countries themselves—the incidence of Guinea worm has been reduced by more than 99 percent.\n\nGuinea worm disease incapacitates victims for extended periods of time making them unable to work or grow enough food to feed their families or attend school."];
    [facts addObject:fact];
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        if(cBlock)
            cBlock(facts, error);
    }];
#else
    
    [BNRConnection connectionWithURLString:@"http://guinea-worm.herokuapp.com/facts.json"
                          startImmediately:YES
                           completionBlock:^(id obj, NSError *err) {
                               
                               NSMutableArray *facts = [NSMutableArray array];
                               
                               for(NSDictionary *d in obj)
                               {
                                   BNRFact *fact = [[BNRFact alloc] init];
                                   [fact setQuestion:[d objectForKey:@"question"]];
                                   [fact setAnswer:[d objectForKey:@"answer"]];
                                   [facts addObject:fact];
                               }
                               
                               if(cBlock)
                                   cBlock(facts, err);
                           }];
    
#endif

}

@end
