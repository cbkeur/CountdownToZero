//
//  BNRXIBCell.m
//
//  Created by Joe Conway on 7/14/10.
//  Copyright 2010 Big Nerd Ranch. All rights reserved.
//

#import "BNRXIBCell.h"
#import <objc/runtime.h>

static NSMutableDictionary *BNRXIBCellHeightDictionary = nil;
static NSDateFormatter *BNRXIBCellDateTransformer = nil;

@implementation BNRXIBCellLoader

- (id)loadCellWithClass:(Class)cls
{
    NSString *clsName = NSStringFromClass(cls);
    
    if ([[NSBundle mainBundle] pathForResource:clsName ofType:@"nib"]) 
		[[NSBundle mainBundle] loadNibNamed:clsName owner:self options:nil];
        
    id retVal = cell;
    [cell cellDidLoad];
    cell = nil;
    return retVal;
}
@end

@interface BNRXIBCell ()
@property (nonatomic, assign) float contentHeight;
+ (id)transformValue:(id)val withFormatString:(NSString *)fmtString;
- (void)dispatchMessage:(SEL)msg toObject:(id)obj fromObject:(UIControl *)ctl;
+ (NSString *)strippedKeyPath:(NSString *)keyPath withFormatString:(NSString **)fmtString;
@end

@implementation BNRXIBCell

@synthesize cellTarget, tableView, contentHeight, representedObject;
+ (void)initialize
{
	if(self == [BNRXIBCell class])
	{
		BNRXIBCellHeightDictionary = [[NSMutableDictionary alloc] init];
		BNRXIBCellDateTransformer = [[NSDateFormatter alloc] init];
	}
}
- (id)initWithCoder:(NSCoder *)coder
{
    if ((self = [super initWithCoder:coder])) 
    {
		contentHeight = [self bounds].size.height;
		mapDictionary = [[NSMutableDictionary alloc] init];        
    }
    return self;
}
- (id)initWithStyle:(UITableViewCellStyle)style
{
	NSString *cellName = [[self class] reuseIdentifier];
	self = [super initWithStyle:style reuseIdentifier:cellName];
	if ([[NSBundle mainBundle] pathForResource:cellName ofType:@"nib"]) {		
		[[NSBundle mainBundle] loadNibNamed:cellName owner:self options:nil];
		
        [[self contentView] addSubview:contentViewContents];
		contentHeight = [contentViewContents bounds].size.height;
		
		contentViewContents = nil;
		mapDictionary = [[NSMutableDictionary alloc] init];
	}

	return self;		
}
/*- (void)layoutSubviews
{
	[super layoutSubviews];
//    [[self contentView] setFrame:[self bounds]];
}*/
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier 
{
	NSLog(@"Ignoring use of '%@' as reuseIdentifier for %@", reuseIdentifier, self); 
	return [self initWithStyle:style];
}
- (id)init
{
	return [self initWithStyle:UITableViewCellStyleDefault];
}
- (void)cellDidLoad
{
    
}
- (void)mapRepresentedObjectKey:(NSString *)val toCellKey:(NSString *)field
{
	mapDictionary[field] = val;
}

- (void)setRepresentedObject:(id)o
{
    representedObject = o;
	// Must also find key path for incoming object...
	for(NSString *k in mapDictionary)
	{
		NSString *fmtString = nil;
		NSString *keyPath = [BNRXIBCell strippedKeyPath:mapDictionary[k] 
                                       withFormatString:&fmtString];
		id val = [o valueForKeyPath:keyPath];
//        id formattedVal = [BNRXIBCell transformValue:val withFormatString:fmtString];
		[self setValue:val forKeyPath:k];	
	}
    representedObject = nil;
}
+ (NSString *)strippedKeyPath:(NSString *)keyPath withFormatString:(NSString **)fmtString
{
	NSRange colonRange = [keyPath rangeOfString:@":"];
	if(colonRange.location != NSNotFound)
	{
		NSString *kp = [keyPath substringToIndex:colonRange.location];
		*fmtString = [keyPath substringFromIndex:colonRange.location + 1];
		return kp;
	}
	
	*fmtString = nil;
	return keyPath;
}
+ (id)transformValue:(id)val withFormatString:(NSString *)fmtString
{
	if(fmtString)
	{
		if([fmtString length] == 0)
		{
			[NSException raise:@"Empty format string" format:@"Format string for BNRXIBCell is empty"];
			return nil;
		}
		NSRange dRange = [fmtString rangeOfString:@"D"];
		if(dRange.location != NSNotFound)
		{
			if([fmtString length] != 3)
			{
				[NSException raise:@"Invalid format string" 
							format:@"Date format string must be format DXX (%@)", fmtString];
				return nil;
			}
			dRange.location ++;
			NSString *timeStyleStr = [fmtString substringWithRange:dRange];
			dRange.location ++;
			NSString *dateStyleStr = [fmtString substringWithRange:dRange];
			NSDateFormatterStyle timeStyle = NSDateFormatterNoStyle;
			NSDateFormatterStyle dateStyle = NSDateFormatterNoStyle;
			if([timeStyleStr isEqual:@"S"])
				timeStyle = NSDateFormatterShortStyle;
			else if([timeStyleStr isEqual:@"M"])
				timeStyle = NSDateFormatterMediumStyle;
			else if([timeStyleStr isEqual:@"L"])
				timeStyle = NSDateFormatterLongStyle;
			else if([timeStyleStr isEqual:@"F"])
				timeStyle = NSDateFormatterFullStyle;
			if([dateStyleStr isEqual:@"S"])
				dateStyle = NSDateFormatterShortStyle;
			else if([dateStyleStr isEqual:@"M"])
				dateStyle = NSDateFormatterMediumStyle;
			else if([dateStyleStr isEqual:@"L"])
				dateStyle = NSDateFormatterLongStyle;
			else if([dateStyleStr isEqual:@"F"])
				dateStyle = NSDateFormatterFullStyle;
			
			[BNRXIBCellDateTransformer setTimeStyle:timeStyle];
			[BNRXIBCellDateTransformer setDateStyle:dateStyle];
			return [BNRXIBCellDateTransformer stringFromDate:val];
		}
		[NSException raise:@"Unrecognized format string" format:@"Format string for BNRXIBCell unsupported"];
	}
	
/*	if([val respondsToSelector:@selector(stringValue)])
	{
		return [val stringValue];
	}*/

	return val;
}
+ (NSString *)reuseIdentifier
{
	return NSStringFromClass(self);
}
- (NSString *)reuseIdentifier
{
	return NSStringFromClass([self class]);
}
+ (CGFloat)desiredHeight
{
	NSString *cellClass = NSStringFromClass(self);
	NSNumber *num = BNRXIBCellHeightDictionary[cellClass];
	if(!num)
	{
		BNRXIBCell *c = [self cellForTableView:nil target:nil configure:nil];
		float h = [c contentHeight];
		if(h == 0.0)
			h = 44.0;
		
		num = @(h);
		
		BNRXIBCellHeightDictionary[cellClass] = num;
	}
	return [num floatValue];
}
+ (id)cellForTableView:(UITableView *)tv target:(id)targ configure:(BOOL *)flag
{
	UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:[self reuseIdentifier]];
	if(!cell)
	{
        BNRXIBCellLoader *loader = [[BNRXIBCellLoader alloc] init];
		cell = [loader loadCellWithClass:self];
		if(flag)
			*flag = YES;
	}	
	else if(flag)
		*flag = NO;

	[(BNRXIBCell *)cell setCellTarget:targ];
	[(BNRXIBCell *)cell setTableView:tv];
	
	return cell;
}
- (void)routeAction:(SEL)act fromObject:(id)obj
{
	[self dispatchMessage:act toObject:cellTarget fromObject:obj];
}

- (void)dispatchMessage:(SEL)msg toObject:(id)obj fromObject:(UIControl *)ctl
{
	SEL newSel = NSSelectorFromString([NSStringFromSelector(msg) stringByAppendingFormat:@"atIndexPath:"]);
	NSIndexPath *ip = [tableView indexPathForCell:self];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [obj performSelector:newSel withObject:ctl withObject:ip];
#pragma clang diagnostic pop
}







@end
