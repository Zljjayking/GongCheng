//
//  DDCompanyDetailInfoCell.h
//  GongChengDD
//
//  Created by xzx on 2018/5/11.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDCompanyDetailModel1.h"

@interface DDCompanyDetailInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIButton *refreshBtn;
@property (weak, nonatomic) IBOutlet UILabel *refreshTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *seenLab;

@property (weak, nonatomic) IBOutlet UILabel *peopleLab1;
@property (weak, nonatomic) IBOutlet UIButton *peopleBtn;

@property (weak, nonatomic) IBOutlet UILabel *moneyLab1;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab2;

@property (weak, nonatomic) IBOutlet UILabel *timeLab1;
@property (weak, nonatomic) IBOutlet UILabel *timeLab2;

@property (weak, nonatomic) IBOutlet UILabel *lineLab;

@property (weak, nonatomic) IBOutlet UIButton *telBtn;
@property (weak, nonatomic) IBOutlet UIButton *goCheckBtn;

@property (weak, nonatomic) IBOutlet UIButton *moreInfoBtn;
@property (weak, nonatomic) IBOutlet UILabel *statusLab;
@property (weak, nonatomic) IBOutlet UIButton *usedNameBtn;
@property (weak, nonatomic) IBOutlet UIButton *billBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *usedNameWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *seperateWidth2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *seperateWidth1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusLabWidth;
@property (weak, nonatomic) IBOutlet UILabel *countTitle;
@property (weak, nonatomic) IBOutlet UILabel *countContent;
@property (weak, nonatomic) IBOutlet UIView *peopleV;

-(void)loadDataWithModel:(DDCompanyDetailModel1 *)model;

@end
