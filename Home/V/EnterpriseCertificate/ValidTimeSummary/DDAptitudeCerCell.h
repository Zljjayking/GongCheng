//
//  DDAptitudeCerCell.h
//  GongChengDD
//
//  Created by csq on 2018/8/23.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDEnterpriseCertificateSummaryModel.h"

/**
 资质证书cell
 */
@interface DDAptitudeCerCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *cerNumLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *markLab;

@property (weak, nonatomic) IBOutlet UILabel *daysLab;
@property (weak, nonatomic) IBOutlet UILabel *subDaysLab;

//资质证书有效期
- (void)loadCellWithQualificationValidityModel:(QualificationValidityModel *)model;

+(CGFloat)height;

@end
