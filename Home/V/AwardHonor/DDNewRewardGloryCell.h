//
//  DDNewRewardGloryCell.h
//  GongChengDD
//
//  Created by hou qiangqiang on 2019/1/23.
//  Copyright © 2019 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDSearchRewardGloryListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DDNewRewardGloryCell : UITableViewCell
@property (strong, nonatomic) UILabel *nameLab;
@property (strong, nonatomic) UILabel *rewardLab1;
@property (strong, nonatomic) UILabel *rewardLab2;
@property (strong, nonatomic) UILabel *deptLab1;
@property (strong, nonatomic) UILabel *deptLab2;
@property (strong, nonatomic) UILabel *timeLab1;
@property (strong, nonatomic) UILabel *timeLab2;
@property (strong, nonatomic) UIImageView *arrowImgV;
//获奖荣誉使用
-(void)loadDataWithModel:(DDSearchRewardGloryListModel *)model;
@end

NS_ASSUME_NONNULL_END
