//
//  DDPeopleBelongCerti2Cell.h
//  GongChengDD
//
//  Created by xzx on 2018/10/10.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDPeopleBelongCertiModel.h"

NS_ASSUME_NONNULL_BEGIN

@class DDPeopleBelongCerti2Cell;
@protocol DDPeopleBelongCerti2CellDelegate <NSObject>
@optional
//点击认领
- (void)peopleBelongCerti2CellClaimClick:(DDPeopleBelongCerti2Cell*)cell;

@end


@interface DDPeopleBelongCerti2Cell : UITableViewCell
//建造师专用
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
@property (weak, nonatomic) IBOutlet UILabel *registerLab1;
@property (weak, nonatomic) IBOutlet UILabel *registerLab2;
@property (weak, nonatomic) IBOutlet UILabel *tempLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *roleLabWidth;
@property (weak, nonatomic) IBOutlet UIButton *claimButton;
@property (weak, nonatomic) IBOutlet UIImageView *arrow;
@property (weak,nonatomic)id<DDPeopleBelongCerti2CellDelegate>delegate;

-(void)loadDataWithModel:(DDPeopleBelongCertiModel *)model;

+(CGFloat)height;

@end

NS_ASSUME_NONNULL_END
