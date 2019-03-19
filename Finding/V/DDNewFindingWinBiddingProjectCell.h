//
//  DDNewFindingWinBiddingProjectCell.h
//  GongChengDD
//
//  Created by hou qiangqiang on 2019/1/21.
//  Copyright © 2019 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDSearchProjectListModel.h"//model
#import "DDMyCollectModel.h"//model
#import "DDNewInviteListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDNewFindingWinBiddingProjectCell : UITableViewCell
@property (strong, nonatomic) UILabel *titleLab;
@property (strong, nonatomic) UILabel *winLab;
@property (strong, nonatomic) UILabel *winBiddingLab;
@property (strong, nonatomic) UIButton *winBiddingBtn;
@property (strong, nonatomic) UILabel *priceLab1;
@property (strong, nonatomic) UILabel *priceLab2;
@property (strong, nonatomic) UILabel *timeLab1;
@property (strong, nonatomic) UILabel *timeLab2;

-(void)loadDataWithModel3:(DDSearchProjectListModel *)model;
-(void)loadDataWithModel:(DDSearchProjectListModel *)model;
-(void)loadDataWithModel2:(DDMyCollectModel *)model;
-(void)loadDataWithModel4:(DDNewInviteListModel *)model;
-(void)loadDataWithModel5:(DDSearchProjectListModel *)model;//中标情况
-(void)loadDataWithModel6:(DDMyCollectModel *)model;//我的收藏，中标项目
@end

NS_ASSUME_NONNULL_END
