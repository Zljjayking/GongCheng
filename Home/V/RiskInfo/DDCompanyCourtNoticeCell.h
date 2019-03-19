//
//  DDCompanyCourtNoticeCell.h
//  GongChengDD
//
//  Created by xzx on 2018/6/5.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDCompanyCourtNoticeModel.h"

@interface DDCompanyCourtNoticeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *typeLab1;
@property (weak, nonatomic) IBOutlet UILabel *typeLab2;
@property (weak, nonatomic) IBOutlet UILabel *peopleLab1;
@property (weak, nonatomic) IBOutlet UILabel *peopleLab2;
@property (weak, nonatomic) IBOutlet UILabel *publishTimeLab1;
@property (weak, nonatomic) IBOutlet UILabel *publishTimeLab2;

-(void)loadDataWithModel:(DDCompanyCourtNoticeModel *)model;

@end
