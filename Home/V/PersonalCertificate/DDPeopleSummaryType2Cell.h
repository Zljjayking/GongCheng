//
//  DDPeopleSummaryType2Cell.h
//  GongChengDD
//
//  Created by csq on 2018/10/26.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDPeopleSummaryModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDPeopleSummaryType2Cell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLab;//姓名
@property (weak, nonatomic) IBOutlet UILabel *typeNameLab;//类型名称

@property (weak, nonatomic) IBOutlet UILabel *cerNumMarkLab;
@property (weak, nonatomic) IBOutlet UILabel *cerNumLab;//证书编号

@property (weak, nonatomic) IBOutlet UILabel *registerNumMarkLab;
@property (weak, nonatomic) IBOutlet UILabel *registerNumLab;//注册号

@property (weak, nonatomic) IBOutlet UILabel *validityPeriodEndMarkLab;
@property (weak, nonatomic) IBOutlet UILabel *validityPeriodEndLab;//有效期

-(void)loadWithModel:(DDPeopleSummaryModel *)model indexPath:(NSIndexPath *)indexPath;
//消防
- (void)loadFireControlWithModel:(DDPeopleSummaryModel *)model indexPath:(NSIndexPath *)indexPath;

+ (CGFloat)height;
@end

NS_ASSUME_NONNULL_END
