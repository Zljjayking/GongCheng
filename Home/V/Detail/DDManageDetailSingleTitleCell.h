//
//  DDManageDetailSingleTitleCell.h
//  GongChengDD
//
//  Created by csq on 2018/9/19.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDManageDetailSingleTitleCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel * nameLab;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;

- (void)loadWithName:(NSString*)name;
//施工工法section == 0用
- (void)loadWithWorkLawDetailName:(NSString*)name;

//可变高度
- (CGFloat)height;

@end

NS_ASSUME_NONNULL_END
