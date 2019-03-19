//
//  DDFireEngineerMoreEduCell.h
//  GongChengDD
//
//  Created by xzx on 2018/9/26.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDFireEngineerMoreEduModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDFireEngineerMoreEduCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *yearLab1;
@property (weak, nonatomic) IBOutlet UILabel *yearLab2;
@property (weak, nonatomic) IBOutlet UILabel *lineLab;
@property (weak, nonatomic) IBOutlet UILabel *dateLab1;
@property (weak, nonatomic) IBOutlet UILabel *dateLab2;
@property (weak, nonatomic) IBOutlet UILabel *statusLab1;
@property (weak, nonatomic) IBOutlet UILabel *statusLab2;
-(void)loadDataWithModel:(DDFireEngineerMoreEduModel *)model;

@end

NS_ASSUME_NONNULL_END
