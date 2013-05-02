//
//  BNRConnection.m
//  Nerdfeed
//
//  Created by joeconway on 1/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BNRConnection.h"

static NSMutableArray *sharedConnectionList = nil;

@implementation BNRConnection
@synthesize request, completionBlock;

+ (id)connectionWithURLString:(NSString *)urlStr startImmediately:(BOOL)flag completionBlock:(void (^)(id obj, NSError *err))cBlock
{
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    BNRConnection *conn = [[self alloc] initWithRequest:req];
    [conn setCompletionBlock:cBlock];
    if(flag)
        [conn start];
    
    return conn;
}

- (id)initWithRequest:(NSURLRequest *)req
{
    self = [super init];
    if(self) {
        [self setRequest:req];
    }
    return self;
}

- (void)start
{
    // Initialize container for data collected from NSURLConnection
    container = [[NSMutableData alloc] init];
    
    // Spawn connection
    internalConnection = [[NSURLConnection alloc] initWithRequest:[self request]
                                                         delegate:self 
                                                 startImmediately:YES];

    // If this is the first connection started, create the array
    if(!sharedConnectionList)
        sharedConnectionList = [[NSMutableArray alloc] init];
    
    // Add the connection to the array so it doesn't get destroyed
    [sharedConnectionList addObject:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [container appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{    
    NSError *err = nil;
    id jsonObj = [NSJSONSerialization JSONObjectWithData:container options:0 error:&err];
    
    if([self completionBlock])
    {
        if(jsonObj)
            [self completionBlock](jsonObj, nil);
        else
            [self completionBlock](nil, err);
    }
    
    // Now, destroy this connection
    [sharedConnectionList removeObject:self];
}
- (void)connection:(NSURLConnection *)connection 
  didFailWithError:(NSError *)error
{
    // Pass the error from the connection to the completionBlock
    if([self completionBlock]) 
        [self completionBlock](nil, error);
    
    // Destroy this connection
    [sharedConnectionList removeObject:self];
}

@end
