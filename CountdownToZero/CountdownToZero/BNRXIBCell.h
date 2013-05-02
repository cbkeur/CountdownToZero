//
//  BNRXIBCell.h
//
//  Created by Joe Conway on 7/14/10.
//  Copyright 2010 Big Nerd Ranch. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ROUTE(x) [self routeAction:_cmd fromObject:x]

@interface BNRXIBCellLoader : NSObject
{
    IBOutlet id cell;
}
- (id)loadCellWithClass:(Class)cls;
@end


@interface BNRXIBCell : UITableViewCell {
	IBOutlet UIView *contentViewContents;
	UITableView * __weak tableView;
	id __weak target;
	float contentHeight;
	id __weak representedObject;
	NSMutableDictionary *mapDictionary;
}
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) id representedObject;
@property (nonatomic, weak) id cellTarget;


+ (NSString *)reuseIdentifier;
+ (id)cellForTableView:(UITableView *)tv target:(id)targ configure:(BOOL *)flag;

- (id)initWithStyle:(UITableViewCellStyle)style;
- (void)routeAction:(SEL)act fromObject:(id)obj;
- (void)mapRepresentedObjectKey:(NSString *)val toCellKey:(NSString *)field;



// Override this if needed
+ (CGFloat)desiredHeight;
- (void)cellDidLoad;
@end