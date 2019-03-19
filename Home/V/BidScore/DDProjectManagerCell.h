//
//  DDProjectManagerCell.h
//  GongChengDD
//
//  Created by csq on 2018/5/30.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDProjectManagerModel.h"

@interface DDProjectManagerCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *projectManagerLab;

//证书
@property (weak, nonatomic) IBOutlet UILabel *certificateLab;
@property (weak, nonatomic) IBOutlet UILabel *certificateNumLab;

//承接项目
@property (weak, nonatomic) IBOutlet UILabel *projectLab;
@property (weak, nonatomic) IBOutlet UILabel *projectNumLab;

//行政处罚
@property (weak, nonatomic) IBOutlet UILabel *punishLab;
@property (weak, nonatomic) IBOutlet UILabel *punishNumLab;

//获奖荣誉
@property (weak, nonatomic) IBOutlet UILabel *rewardLab;
@property (weak, nonatomic) IBOutlet UILabel *rewardNumLab;

- (void)loadWithModel:(DDProjectManagerModel*)model;

+ (CGFloat)height;

@end
