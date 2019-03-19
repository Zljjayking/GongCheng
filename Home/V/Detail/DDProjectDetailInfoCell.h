//
//  DDProjectDetailInfoCell.h
//  GongChengDD
//
//  Created by xzx on 2018/5/23.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDGainBiddingDetailModel.h"
#import "DDProjectDetailModel.h"


@interface DDProjectDetailInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *managerLab1;
@property (weak, nonatomic) IBOutlet UILabel *managerLab2;
@property (weak, nonatomic) IBOutlet UILabel *biddingPriceLab1;
@property (weak, nonatomic) IBOutlet UILabel *biddingPriceLab2;
@property (weak, nonatomic) IBOutlet UILabel *biddingTimeLab1;
@property (weak, nonatomic) IBOutlet UILabel *biddingTimeLab2;
//中标或PPP项目详情,使用
- (void)loadWithModel:(DDGainBiddingDetailModel*)model;
+ (CGFloat)heightWithModel:(DDGainBiddingDetailModel*)model;

//其它详情
- (void)loadWithProjectDetailModel:(DDProjectDetailModel*)model;
+ (CGFloat)heightWithProjectDetailModel:(DDProjectDetailModel*)model;
@end
