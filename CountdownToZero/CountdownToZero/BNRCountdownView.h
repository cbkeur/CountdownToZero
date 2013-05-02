//
//  BNRCountdownView.h
//  CountdownToZero
//
//  Created by Christian Keur on 5/1/13.
//  Copyright (c) 2013 Christian Keur. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BNRCountdownView : UIView

- (void)countdownFrom:(int)fromValue to:(int)toValue duration:(float)duration completion:(void (^)(void))cBlock;

@end
