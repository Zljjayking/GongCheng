//
//  DDTaxIllegalCell.h
//  GongChengDD
//
//  Created by xzx on 2018/10/26.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDTaxIllegalModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDTaxIllegalCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *propertyLab1;
@property (weak, nonatomic) IBOutlet UILabel *propertyLab2;
@property (weak, nonatomic) IBOutlet UILabel *timeLab1;
@property (weak, nonatomic) IBOutlet UILabel *timeLab2;
@property (weak, nonatomic) IBOutlet UILabel *deptLab1;
@property (weak, nonatomic) IBOutlet UILabel *deptLab2;

-(void)loadDataWithModel:(DDTaxIllegalModel *)model;

@end

NS_ASSUME_NONNULL_END
