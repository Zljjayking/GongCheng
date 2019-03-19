//
//  DDCompanyLoseCreditCell.h
//  GongChengDD
//
//  Created by xzx on 2018/8/21.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDCompanyExcutedModel.h"

@interface DDCompanyLoseCreditCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UILabel *courtLab1;
@property (weak, nonatomic) IBOutlet UILabel *courtLab2;
@property (weak, nonatomic) IBOutlet UILabel *createTimeLab1;
@property (weak, nonatomic) IBOutlet UILabel *createTimeLab2;
@property (weak, nonatomic) IBOutlet UILabel *publishTimeLab1;
@property (weak, nonatomic) IBOutlet UILabel *publishTimeLab2;

-(void)loadDataWithModel:(DDCompanyExcutedModel *)model;

@end
