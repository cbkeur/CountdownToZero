//
//  BNRFactCell.h
//  CountdownToZero
//
//  Created by Christian Keur on 5/2/13.
//  Copyright (c) 2013 Christian Keur. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BNRXIBCell.h"

@interface BNRFactCell : BNRXIBCell

@property (weak, nonatomic) IBOutlet UILabel *factLabel;

+ (float)heightForCellWithString:(NSString *)str;

- (void)setFactText:(NSString *)str;

@end
