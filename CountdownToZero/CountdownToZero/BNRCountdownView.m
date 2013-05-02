//
//  BNRCountdownView.m
//  CountdownToZero
//
//  Created by Christian Keur on 5/1/13.
//  Copyright (c) 2013 Christian Keur. All rights reserved.
//

#import "BNRCountdownView.h"

@interface BNRCountdownView ()

@property (weak, nonatomic) UILabel *numberLabel;

@property (nonatomic) int currentValue;
@property (nonatomic) int finalValue;
@property (nonatomic) float duration;
@property (nonatomic) int skipInterval;

@end

@implementation BNRCountdownView

#pragma mark - Initializers

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
    UILabel *l = [[UILabel alloc] initWithFrame:self.bounds];
    [l setBackgroundColor:[UIColor clearColor]];
    [l setTextColor:[UIColor blueColor]];
    [l setTextAlignment:NSTextAlignmentCenter];
    [l setFont:[UIFont boldSystemFontOfSize:36]];
    [self addSubview:l];
    
    _numberLabel = l;
}

#pragma mark - Actions

- (void)countdownFrom:(int)fromValue to:(int)toValue duration:(float)duration completion:(void (^)(void))cBlock
{
    _currentValue = fromValue;
    _finalValue = toValue;
    _duration = duration;
    
    
    int iterations = duration / 0.01;
    _skipInterval = (fromValue - toValue) / iterations;
    
    [_numberLabel setText:[NSString stringWithFormat:@"%i", fromValue]];
    
    [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
}

- (void)timerFired:(NSTimer *)timer
{
    _currentValue -= _skipInterval;
    if(_currentValue < _finalValue)
        _currentValue = _finalValue;
    
    [_numberLabel setText:[NSString stringWithFormat:@"%i", _currentValue]];
    
    if(_currentValue == _finalValue)
        [timer invalidate];
}

@end
