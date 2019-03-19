//
//  DDOweTaxNoticeCell.h
//  GongChengDD
//
//  Created by xzx on 2018/10/26.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDOweTaxNoticeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDOweTaxNoticeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *numberLab1;
@property (weak, nonatomic) IBOutlet UILabel *numberLab2;
@property (weak, nonatomic) IBOutlet UILabel *timeLab1;
@property (weak, nonatomic) IBOutlet UILabel *timeLab2;
@property (weak, nonatomic) IBOutlet UILabel *kindLab1;
@property (weak, nonatomic) IBOutlet UILabel *kindLab2;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab1;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab2;
@property (weak, nonatomic) IBOutlet UILabel *deptLab1;
@property (weak, nonatomic) IBOutlet UILabel *deptLab2;
@property (weak, nonatomic) IBOutlet UILabel *line1;
@property (weak, nonatomic) IBOutlet UILabel *line2;

-(void)loadDataWithModel:(DDOweTaxNoticeModel *)model;

@end

NS_ASSUME_NONNULL_END
