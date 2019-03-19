//
//  DDFireEngineerPunishCell.h
//  GongChengDD
//
//  Created by xzx on 2018/9/26.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDFireEngineerPunishModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDFireEngineerPunishCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dateLab1;
@property (weak, nonatomic) IBOutlet UILabel *dateLab2;
@property (weak, nonatomic) IBOutlet UILabel *lineLab1;
@property (weak, nonatomic) IBOutlet UILabel *typeLab1;
@property (weak, nonatomic) IBOutlet UILabel *typeLab2;
@property (weak, nonatomic) IBOutlet UILabel *deptLab1;
@property (weak, nonatomic) IBOutlet UILabel *deptLab2;
@property (weak, nonatomic) IBOutlet UILabel *lineLab2;
@property (weak, nonatomic) IBOutlet UILabel *punishLab1;
@property (weak, nonatomic) IBOutlet UILabel *punishLab2;
@property (weak, nonatomic) IBOutlet UILabel *causeLab1;
@property (weak, nonatomic) IBOutlet UILabel *causeLab2;
@property (weak, nonatomic) IBOutlet UILabel *lineLab3;
@property (weak, nonatomic) IBOutlet UILabel *projectLab1;
@property (weak, nonatomic) IBOutlet UILabel *projectLab2;

-(void)loadDataWithModel:(DDFireEngineerPunishModel *)model;

@end

NS_ASSUME_NONNULL_END
