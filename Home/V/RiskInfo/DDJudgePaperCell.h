//
//  DDJudgePaperCell.h
//  GongChengDD
//
//  Created by xzx on 2018/6/4.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDSearchJudgePaperListModel.h"//model

@interface DDJudgePaperCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *numLab1;
@property (weak, nonatomic) IBOutlet UILabel *numLab2;
@property (weak, nonatomic) IBOutlet UILabel *dateLab1;
@property (weak, nonatomic) IBOutlet UILabel *dateLab2;
@property (weak, nonatomic) IBOutlet UILabel *roleLab1;
@property (weak, nonatomic) IBOutlet UILabel *roleLab2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabHeight;

-(void)loadDataWithModel:(DDSearchJudgePaperListModel *)model;

@end
