//
//  DDExamNotifyCell.h
//  GongChengDD
//
//  Created by hou qiangqiang on 2019/2/21.
//  Copyright © 2019 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DDExamNotifyCellDelegate <NSObject>

-(void)hasClickedWithIndex:(NSInteger)rowIndex;

@end

NS_ASSUME_NONNULL_BEGIN

@interface DDExamNotifyCell : UITableViewCell
@property(nonatomic,strong) UILabel *titleL;
@property(nonatomic,strong) UILabel *lineL;
@property(nonatomic,strong) NSArray *indexArr;
@property(nonatomic,weak)id <DDExamNotifyCellDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
