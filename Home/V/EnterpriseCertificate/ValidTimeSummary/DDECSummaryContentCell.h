//
//  DDECSummaryContentCell.h
//  GongChengDD
//
//  Created by csq on 2017/12/4.
//  Copyright © 2017年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDEnterpriseCertificateSummaryModel.h"

@interface DDECSummaryContentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *daysLab;
@property (weak, nonatomic) IBOutlet UILabel *subDaysLab;
@property (weak, nonatomic) IBOutlet UIImageView *arrow;
@property (assign, nonatomic)BOOL isHiddenTitleLabel;//是否隐藏TitleLab
@property (weak, nonatomic) IBOutlet UILabel *markLab;


//营业执照工商年报
- (void)loadeCellWithBusinessTimeString:(NSString*)timeString;


//安全许可证
- (void)loadWithSafetyLicenceModel:(DDSafetyLicenceModel*)model;


@end
