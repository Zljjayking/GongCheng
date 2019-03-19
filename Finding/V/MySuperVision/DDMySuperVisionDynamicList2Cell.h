//
//  DDMySuperVisionDynamicList2Cell.h
//  GongChengDD
//
//  Created by xzx on 2018/12/1.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDMySuperVisionDynamicListModel.h"//model

NS_ASSUME_NONNULL_BEGIN

@interface DDMySuperVisionDynamicList2Cell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *tipLab1;
@property (weak, nonatomic) IBOutlet UILabel *tipLab2;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *pointLab;
@property (weak, nonatomic) IBOutlet UILabel *rightTopLab;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *attachLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewHeight;

-(void)loadDataWithModel:(DDMySuperVisionDynamicListModel *)model;

@end

NS_ASSUME_NONNULL_END
