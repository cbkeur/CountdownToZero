//
//  BNRCarterButton.m
//  CountdownToZero
//
//  Created by Christian Keur on 5/2/13.
//  Copyright (c) 2013 Christian Keur. All rights reserved.
//

#import "BNRCarterButton.h"

@implementation BNRCarterButton

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if(self)
    {
        _buttonText = [self titleForState:UIControlStateNormal];
        [self setTitle:nil forState:UIControlStateNormal];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:10];
    [path addClip];
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    NSArray *colors = @[(id)[[UIColor colorWithRed:205/255.0 green:67/255.0 blue:22/255.0 alpha:1] CGColor], (id)[[UIColor colorWithRed:132/255.0 green:43/255.0 blue:10/255.0 alpha:1] CGColor]];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)(colors), NULL);
    CGColorSpaceRelease(colorSpace);
    
    CGPoint startPoint = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMinY(self.bounds));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMaxY(self.bounds));
    
    CGContextDrawLinearGradient(UIGraphicsGetCurrentContext(), gradient, startPoint, endPoint, 0);
    CGGradientRelease(gradient);
    
    CGRect frame = self.bounds;
    frame.origin.x += 3;
    frame.size.width -= 6;
    frame.origin.y += 3;
    frame.size.height -= 6;
    
    path = [UIBezierPath bezierPathWithRoundedRect:frame cornerRadius:8];
    [[UIColor colorWithRed:178/255.0 green:144/255.0 blue:73/255.0 alpha:1] setStroke];
    [path setLineWidth:1.5];
    [path stroke];
    
    [[UIColor whiteColor] set];
    
    NSString *text = _buttonText;
    UIFont *font = [UIFont fontWithName:@"Baskerville" size:22];
    CGSize size = [text sizeWithFont:font constrainedToSize:self.bounds.size];
    
    frame.size = size;
    frame.origin.x = (self.bounds.size.width / 2.0) - (size.width / 2.0);
    frame.origin.y = (self.bounds.size.height / 2.0) - (size.height / 2.0);
    
    [text drawInRect:frame withFont:font];
    
    if([self isHighlighted])
    {
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextMoveToPoint(ctx, 0, 0);
        CGContextAddLineToPoint(ctx, self.bounds.size.width, 0);
        CGContextAddLineToPoint(ctx, self.bounds.size.width, self.bounds.size.height);
        CGContextAddLineToPoint(ctx, 0, self.bounds.size.height);
        [[UIColor colorWithWhite:0 alpha:0.2] set];
        CGContextFillPath(ctx);
    }
}


@end
