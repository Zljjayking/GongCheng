//
//  DDWinTheBiddCell.h
//  GongChengDD
//
//  Created by csq on 2018/5/30.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDWinTheBiddModel.h"


@interface DDWinTheBiddCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (weak, nonatomic) IBOutlet UILabel *winBidOrgLab;
@property (weak, nonatomic) IBOutlet UILabel *winBidOrgLab2;

@property (weak, nonatomic) IBOutlet UILabel *projectMangerMark;
@property (weak, nonatomic) IBOutlet UILabel *projectManagerLab;
@property (weak, nonatomic) IBOutlet UIView *centerLine1;
@property (weak, nonatomic) IBOutlet UIButton *nameBtn;

@property (weak, nonatomic) IBOutlet UILabel *winBidAmountMark;
@property (weak, nonatomic) IBOutlet UILabel *winBidAmountLab;
@property (weak, nonatomic) IBOutlet UIView *centerLine2;

@property (weak, nonatomic) IBOutlet UILabel *publishDateMark;
@property (weak, nonatomic) IBOutlet UILabel *publishDateLab;

- (void)loadWithModel:(DDWinTheBiddModel*)model;

@end
