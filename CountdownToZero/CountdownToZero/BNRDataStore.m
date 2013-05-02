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

- (void)getHeadlineInfoWithCompletion:(void (^)(id obj, NSError *err))cBlock
{
    id data = nil;
    NSError *error = nil;
#ifdef DUMMY_DATA
    data = @{@"title": @"Chad eliminated all cases of guinea worm", @"url" : @"www.google.com"};
#else
    
#endif
    
    if(cBlock)
        cBlock(data, error);
}

- (void)getYearToDateNewCaseCountWithCompletion:(void (^)(int count, NSError *err))cBlock
{
    int count = 0;
    NSError *error = nil;
#ifdef DUMMY_DATA
    count = 6;
#else
    
#endif
    
    if(cBlock)
        cBlock(count, error);
}

#pragma mark - Photos

- (void)getPhotoListWithCompletion:(void (^)(NSArray *photos, NSError *err))cBlock
{
    NSMutableArray *photos = nil;
    NSError *error = nil;
#ifdef DUMMY_DATA
    photos = [NSMutableArray array];
    for(int i = 0; i < 20; i++)
    {
        BNRPhoto *photo = [[BNRPhoto alloc] init];
        [photo setCaption:@"Hello world"];
        [photo setPhotoURL:@"http://www.traveljournals.net/img/1x1transp.png"];
        [photos addObject:photo];
    }
#else
    
#endif
    
    if(cBlock)
        cBlock(photos, error);
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
