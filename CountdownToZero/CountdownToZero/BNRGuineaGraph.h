//
//  BNRGuineaGraph.h
//  CountdownToZero
//
//  Created by Christian Keur on 5/3/13.
//  Copyright (c) 2013 Christian Keur. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BNRGuineaGraphDataSource;

@interface BNRGuineaGraph : UIView

@property (weak, nonatomic) IBOutlet id<BNRGuineaGraphDataSource> dataSource;

- (void)growGraph;

@end

@protocol BNRGuineaGraphDataSource <NSObject>

@required

- (int)numberOfEntriesInGraph:(BNRGuineaGraph *)graph;
- (CGFloat)graph:(BNRGuineaGraph *)graph valueForEntryAtIndex:(int)index;

@optional

- (NSString *)graph:(BNRGuineaGraph *)graph titleForEntryAtIndex:(int)index;
- (UIColor *)graph:(BNRGuineaGraph *)graph colorForEntryAtIndex:(int)index;

@end
