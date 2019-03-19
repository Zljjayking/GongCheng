//
//  DDProjectDetailInfoCell.h
//  GongChengDD
//
//  Created by xzx on 2018/5/23.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDProjectDetailInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *managerLab1;
@property (weak, nonatomic) IBOutlet UILabel *managerLab2;
@property (weak, nonatomic) IBOutlet UILabel *biddingPriceLab1;
@property (weak, nonatomic) IBOutlet UILabel *biddingPriceLab2;
@property (weak, nonatomic) IBOutlet UILabel *biddingTimeLab1;
@property (weak, nonatomic) IBOutlet UILabel *biddingTimeLab2;

+(CGFloat)height;

@end
