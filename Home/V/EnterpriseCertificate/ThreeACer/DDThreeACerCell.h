//
//  DDThreeACerCell.h
//  GongChengDD
//
//  Created by csq on 2018/9/19.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDThreeACerModel.h"
/*
 certTypeSource = "1";
 createdTime = "2018-09-19 09:42:51";
 enclosure = "www.baidu.com";
 enterpriseId = 1;
 enterpriseName = "测试";
 id = 1;
 level = "AAA";
 noticeDate = "2018-09-19 00:00:00"
 ratingOutlook = "稳定";
 type = "初级评级";
 updatedTime = "2018-09-19 09:48:21";
 validityPeriodEnd = "2018-09-19 00:00:00";
 */

NS_ASSUME_NONNULL_BEGIN

@interface DDThreeACerCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *enterpriseNameLab;
@property (weak, nonatomic) IBOutlet UILabel *levelMarkLab;
@property (weak, nonatomic) IBOutlet UILabel *levelLab;
@property (weak, nonatomic) IBOutlet UILabel *validityPeriodEndMarkLab;
@property (weak, nonatomic) IBOutlet UILabel *validityPeriodEndLab;
@property (weak, nonatomic) IBOutlet UIImageView *arrow;

- (void)loadWithModel:(DDThreeACerListModel*)model;
- (CGFloat)height;

@end

NS_ASSUME_NONNULL_END
