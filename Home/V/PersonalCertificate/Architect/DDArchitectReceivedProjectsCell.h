//
//  DDArchitectReceivedProjectsCell.h
//  GongChengDD
//
//  Created by xzx on 2018/9/29.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDArchitectReceivedProjectsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDArchitectReceivedProjectsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *tilteLab;
@property (weak, nonatomic) IBOutlet UILabel *typeLab1;
@property (weak, nonatomic) IBOutlet UILabel *typeLab2;
@property (weak, nonatomic) IBOutlet UILabel *regionLab1;
@property (weak, nonatomic) IBOutlet UILabel *regionLab2;
@property (weak, nonatomic) IBOutlet UILabel *deptLab1;
@property (weak, nonatomic) IBOutlet UILabel *deptLab2;
-(void)loadDataWithModel:(DDArchitectReceivedProjectsModel *)model;
@property (weak, nonatomic) IBOutlet UILabel *codeLab1;
@property (weak, nonatomic) IBOutlet UILabel *codeLab2;

@end

NS_ASSUME_NONNULL_END
