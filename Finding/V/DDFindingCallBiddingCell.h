//
//  DDFindingCallBiddingCell.h
//  GongChengDD
//
//  Created by xzx on 2018/11/23.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDFindingCallBiddingModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDFindingCallBiddingCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIButton *buyBtn;
@property (weak, nonatomic) IBOutlet UILabel *detailLab;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet UILabel *unitLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

-(void)loadDataWithModel:(DDFindingCallBiddingModel *)model;

@end

NS_ASSUME_NONNULL_END
