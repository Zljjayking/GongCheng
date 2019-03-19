//
//  DDFireEngineerExperienceCell.h
//  GongChengDD
//
//  Created by xzx on 2018/9/26.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDFireEngineerExperienceModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDFireEngineerExperienceCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *dutyLab1;
@property (weak, nonatomic) IBOutlet UILabel *dutyLab2;
@property (weak, nonatomic) IBOutlet UILabel *dateLab1;
@property (weak, nonatomic) IBOutlet UILabel *dateLab2;
-(void)loadDataWithModel:(DDFireEngineerExperienceModel *)model;

@end

NS_ASSUME_NONNULL_END
