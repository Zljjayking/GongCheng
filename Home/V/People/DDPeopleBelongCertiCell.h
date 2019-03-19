//
//  DDPeopleBelongCertiCell.h
//  GongChengDD
//
//  Created by xzx on 2018/5/25.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDPeopleBelongCertiModel.h"

@class DDPeopleBelongCertiCell;
@protocol DDPeopleBelongCertiCellDelegate <NSObject>
@optional
//点击认领
- (void)peopleBelongCertiCellClaimClick:(DDPeopleBelongCertiCell*)cell;

@end


@interface DDPeopleBelongCertiCell : UITableViewCell
//安全员，土木工程师等专用
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *roleLab;
@property (weak, nonatomic) IBOutlet UILabel *majorLab1;
@property (weak, nonatomic) IBOutlet UILabel *majorLab2;
@property (weak, nonatomic) IBOutlet UILabel *numLab1;
@property (weak, nonatomic) IBOutlet UILabel *numLab2;
@property (weak, nonatomic) IBOutlet UILabel *isBLab1;
@property (weak, nonatomic) IBOutlet UILabel *isBLab2;
@property (weak, nonatomic) IBOutlet UILabel *timeLab1;
@property (weak, nonatomic) IBOutlet UILabel *timeLab2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *roleLabWidth;
@property (weak, nonatomic) IBOutlet UIButton *claimButton;
@property (weak, nonatomic) IBOutlet UIImageView *arrow;
@property (weak, nonatomic)id<DDPeopleBelongCertiCellDelegate>delegate;

-(void)loadDataWithModel:(DDPeopleBelongCertiModel *)model;

+(CGFloat)height;

@end
