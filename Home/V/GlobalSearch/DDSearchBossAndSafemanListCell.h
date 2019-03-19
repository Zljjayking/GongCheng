//
//  DDSearchBossAndSafemanListCell.h
//  GongChengDD
//
//  Created by xzx on 2018/5/31.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDSearchBuilderAndManagerListModel.h"
#import "DDMyCollectModel.h"

@interface DDSearchBossAndSafemanListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UIView *btnsView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tipsHeight;
@property (weak, nonatomic) IBOutlet UILabel *tipLab;
@property (weak, nonatomic) IBOutlet UILabel *copanyLabels;

@property (nonatomic,assign)NSInteger isappear;


-(void)loadDataWithModel:(DDSearchBuilderAndManagerListModel *)model;
+(CGFloat)heightWithModel:(DDSearchBuilderAndManagerListModel *)model;

-(void)loadDataWithModel2:(DDMyCollectModel *)model;
+(CGFloat)heightWithModel2:(DDMyCollectModel *)model;

@end
