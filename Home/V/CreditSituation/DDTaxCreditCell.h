//
//  DDTaxCreditCell.h
//  GongChengDD
//
//  Created by xzx on 2018/10/27.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDTaxCreditModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDTaxCreditCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLab1;
@property (weak, nonatomic) IBOutlet UILabel *nameLab2;
@property (weak, nonatomic) IBOutlet UILabel *numberLab1;
@property (weak, nonatomic) IBOutlet UILabel *numberLab2;
@property (weak, nonatomic) IBOutlet UILabel *lineLab1;
@property (weak, nonatomic) IBOutlet UILabel *yearLab1;
@property (weak, nonatomic) IBOutlet UILabel *yearLab2;
@property (weak, nonatomic) IBOutlet UILabel *lineLab2;
@property (weak, nonatomic) IBOutlet UILabel *gradeLab1;
@property (weak, nonatomic) IBOutlet UILabel *gradeLab2;

-(void)loadDataWithModel:(DDTaxCreditModel *)model;

@end

NS_ASSUME_NONNULL_END
