//
//  BNRGuineaGraph.m
//  CountdownToZero
//
//  Created by Christian Keur on 5/3/13.
//  Copyright (c) 2013 Christian Keur. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "BNRGuineaGraph.h"

@interface BNRGuineaGraph ()

@property (nonatomic) NSTimeInterval startTimeInterval;
@property (nonatomic) NSTimeInterval duration;
@property (nonatomic) float currentPercent;
@property (nonatomic, getter = isGrowing) BOOL growing;

@end

@implementation BNRGuineaGraph

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self sharedInit];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if(self)
    {
        [self sharedInit];
    }
    
    return self;
}

- (void)sharedInit
{
    _duration = 0.7;
}

- (void)growGraph
{
    _startTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate];
    _growing = YES;
    
    CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(linkFired:)];
    [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)linkFired:(CADisplayLink *)link
{
    NSTimeInterval currentTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate];
    float difference = currentTimeInterval - _startTimeInterval;
    _currentPercent = difference / _duration;
    if(_currentPercent > 1)
    {
        _currentPercent = 1;
        _growing = NO;
        [link invalidate];
    }
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGRect bounds = self.bounds;
    
    int entryCount = [_dataSource numberOfEntriesInGraph:self];
    entryCount = 3;

    float barWidth = 40;
    float allBarsWidth = barWidth * entryCount;
    float spacing = bounds.size.width - allBarsWidth;
    float spacingPerEntry = spacing / entryCount;
    
    float startX = spacingPerEntry / 2.0;
    float startY = bounds.size.height - 30;
    
    
    for(int i = 0; i < entryCount; i++)
    {
        float height = [_dataSource graph:self valueForEntryAtIndex:i];
        if([self isGrowing])
            height *= _currentPercent;
        
        CGContextMoveToPoint(ctx, startX, startY);
        CGContextAddLineToPoint(ctx, startX, startY - height);
        CGContextAddLineToPoint(ctx, startX + barWidth, startY - height);
        CGContextAddLineToPoint(ctx, startX + barWidth, startY);
        
        UIColor *color = nil;
        if([_dataSource respondsToSelector:@selector(graph:colorForEntryAtIndex:)])
            color = [_dataSource graph:self colorForEntryAtIndex:i];
        else
            color = [UIColor carterRedColor];
        [color set];
        CGContextFillPath(ctx);
        
        if([_dataSource respondsToSelector:@selector(graph:titleForEntryAtIndex:)])
        {
            NSString *title = [_dataSource graph:self titleForEntryAtIndex:i];
            CGPoint startPt = CGPointMake(startX, startY);
            [title drawAtPoint:startPt withFont:[UIFont systemFontOfSize:14]];
        }
        
        startX += (barWidth + spacingPerEntry);
    }
}


@end
