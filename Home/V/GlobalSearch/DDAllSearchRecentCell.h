//
//  DDAllSearchRecentCell.h
//  GongChengDD
//
//  Created by xzx on 2018/5/14.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DDAllSearchRecentCell;
@protocol DDAllSearchRecentCellDelegate <NSObject>
@optional
-(void)allSearchRecentCellSelectButton:(DDAllSearchRecentCell *)allSearchRecentCell buttonIndex:(NSInteger)index;
@end

@interface DDAllSearchRecentCell : UITableViewCell
@property(nonatomic,weak) id <DDAllSearchRecentCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIView *btnsView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnsViewHeight;

-(void)loadCellWithBtns:(NSArray *)array;
+(CGFloat)heightWithBtns:(NSArray *)array;
@end
