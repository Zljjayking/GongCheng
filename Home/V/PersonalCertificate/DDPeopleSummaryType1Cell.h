//
//  DDPeopleSummaryType1Cell.h
//  GongChengDD
//
//  Created by csq on 2018/10/26.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDPeopleSummaryModel.h"

NS_ASSUME_NONNULL_BEGIN

//包含:专业,证书编号,注册号,是否有B类证 4个类目
@interface DDPeopleSummaryType1Cell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLab;//姓名
@property (weak, nonatomic) IBOutlet UILabel *typeNameLab;//类型名称
@property (weak, nonatomic) IBOutlet UILabel *roleLabel;//临时

@property (weak, nonatomic) IBOutlet UILabel *specialityNameMarkLab;
@property (weak, nonatomic) IBOutlet UILabel *specialityNameLab;//专业

@property (weak, nonatomic) IBOutlet UILabel *cerNumMarkLab;
@property (weak, nonatomic) IBOutlet UILabel *cerNumLab;//证书编号

@property (weak, nonatomic) IBOutlet UILabel *registerNumMarkLab;
@property (weak, nonatomic) IBOutlet UILabel *registerNumLab;//注册号

@property (weak, nonatomic) IBOutlet UILabel *hasBCertificateMarkLab;
@property (weak, nonatomic) IBOutlet UILabel *hasBCertificateLab;//B类证情况

@property (weak, nonatomic) IBOutlet UILabel *validityPeriodEndMarkLab;
@property (weak, nonatomic) IBOutlet UILabel *validityPeriodEndLab;//有效期
@property (weak, nonatomic) IBOutlet UIButton *makeBtn;

//一级建造师 二级建造师
-(void)loadCellWithModel:(DDPeopleSummaryModel *)model indexPath:(NSIndexPath *)indexPath;

+ (CGFloat)height;

@end

NS_ASSUME_NONNULL_END
