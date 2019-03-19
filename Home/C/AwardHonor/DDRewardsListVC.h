//
//  DDRewardsListVC.h
//  GongChengDD
//
//  Created by xzx on 2018/10/22.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDRewardsListVC : UIViewController

@property (nonatomic,strong) NSString *enterpriseId;
@property (nonatomic,strong) NSString *toAction;
@property (nonatomic,strong) NSString *rewardType;//1表示技术创新奖，2表示QC奖

@end

NS_ASSUME_NONNULL_END
