//
//  DDCompanyExcutedCell.h
//  GongChengDD
//
//  Created by xzx on 2018/6/5.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDCompanyExcutedModel.h"

@interface DDCompanyExcutedCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UILabel *aimLab1;
@property (weak, nonatomic) IBOutlet UILabel *aimLab2;
@property (weak, nonatomic) IBOutlet UILabel *courtLab1;
@property (weak, nonatomic) IBOutlet UILabel *courtLab2;
@property (weak, nonatomic) IBOutlet UILabel *createTimeLab1;
@property (weak, nonatomic) IBOutlet UILabel *createTimeLab2;
@property (weak, nonatomic) IBOutlet UILabel *publishTimeLab1;
@property (weak, nonatomic) IBOutlet UILabel *publishTimeLab2;

-(void)loadDataWithModel:(DDCompanyExcutedModel *)model;

@end
