//
//  DDMySuperVisionDynamicList1Cell.h
//  GongChengDD
//
//  Created by xzx on 2018/12/1.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDMySuperVisionDynamicListModel.h"//model

NS_ASSUME_NONNULL_BEGIN

@interface DDMySuperVisionDynamicList1Cell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *tipLab1;
@property (weak, nonatomic) IBOutlet UILabel *tipLab2;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *pointLab;
@property (weak, nonatomic) IBOutlet UILabel *detailLab1;
@property (weak, nonatomic) IBOutlet UILabel *detailLab2;
@property (weak, nonatomic) IBOutlet UILabel *detailLab3;
@property (weak, nonatomic) IBOutlet UIButton *makeBtn;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

-(void)loadDataWithModel:(DDMySuperVisionDynamicListModel *)model;

@end

NS_ASSUME_NONNULL_END
