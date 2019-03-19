//
//  DDPeopleSummaryCell.h
//  GongChengDD
//
//  Created by Koncendy on 2017/12/4.
//  Copyright © 2017年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDPeopleSummaryModel.h"

@interface DDPeopleSummaryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UILabel *nameLab;//姓名
@property (weak, nonatomic) IBOutlet UILabel *typeNameLab;//类型名称

@property (weak, nonatomic) IBOutlet UILabel *specialityNameMarkLab;
@property (weak, nonatomic) IBOutlet UILabel *specialityNameLab;//专业

@property (weak, nonatomic) IBOutlet UILabel *staffInfoMarkLab;
@property (weak, nonatomic) IBOutlet UILabel *staffInfoLab;//

@property (weak, nonatomic) IBOutlet UILabel *hasBCertificateMarkLab;
@property (weak, nonatomic) IBOutlet UILabel *hasBCertificateLab;//B类证情况

@property (weak, nonatomic) IBOutlet UILabel *validityPeriodEndMarkLab;
@property (weak, nonatomic) IBOutlet UILabel *validityPeriodEndLab;//有效期
@property (weak, nonatomic) IBOutlet UIButton *makeBtn;

// 8土木工程师   9公用设备师  10电气工程师   11监理工程师  12造价工程师   13消防工程师
- (void)loadOtherManWithModel:(DDPeopleSummaryModel *)model indexPath:(NSIndexPath *)indexPath;
//安全员
- (void)loadSafeManWithModel:(DDPeopleSummaryModel *)model indexPath:(NSIndexPath *)indexPath;

+ (CGFloat)height;

@end
