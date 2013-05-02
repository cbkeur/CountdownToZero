#import <Foundation/Foundation.h>


@interface BNRConnection : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate>
{
    NSURLConnection *internalConnection;
    NSMutableData *container;
}

@property (nonatomic, copy) NSURLRequest *request;
@property (nonatomic, copy) void (^completionBlock)(id obj, NSError *err);

+ (id)connectionWithURLString:(NSString *)urlStr startImmediately:(BOOL)flag completionBlock:(void (^)(id obj, NSError *err))cBlock;

- (id)initWithRequest:(NSURLRequest *)req;
- (void)start;

@end
