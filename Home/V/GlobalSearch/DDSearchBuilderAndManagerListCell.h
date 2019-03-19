//
//  DDSearchBuilderAndManagerListCell.h
//  GongChengDD
//
//  Created by xzx on 2018/5/31.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDSearchBuilderAndManagerListModel.h"

@interface DDSearchBuilderAndManagerListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UIView *btnsView;

@property (weak, nonatomic) IBOutlet UILabel *certiLab1;
@property (weak, nonatomic) IBOutlet UILabel *certiLab2;
@property (weak, nonatomic) IBOutlet UILabel *projectLab1;
@property (weak, nonatomic) IBOutlet UILabel *projectLab2;
@property (weak, nonatomic) IBOutlet UILabel *punishLab1;
@property (weak, nonatomic) IBOutlet UILabel *punishLab2;
@property (weak, nonatomic) IBOutlet UILabel *gloryLab1;
@property (weak, nonatomic) IBOutlet UILabel *gloryLab2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tipsHeight;
@property (weak, nonatomic) IBOutlet UILabel *line1;
@property (weak, nonatomic) IBOutlet UILabel *line2;
@property (weak, nonatomic) IBOutlet UILabel *line3;

-(void)loadDataWithModel:(DDSearchBuilderAndManagerListModel *)model;
+(CGFloat)heightWithModel:(DDSearchBuilderAndManagerListModel *)model;

@end
