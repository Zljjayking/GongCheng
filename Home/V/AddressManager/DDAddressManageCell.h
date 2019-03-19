//
//  DDAddressManageCell.h
//  GongChengDD
//
//  Created by xzx on 2018/7/3.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDAddressManageCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *telLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UILabel *seperateLine;

@property (weak, nonatomic) IBOutlet UIImageView *defaultImg;
@property (weak, nonatomic) IBOutlet UILabel *defaultLab;
@property (weak, nonatomic) IBOutlet UIImageView *editImg;
@property (weak, nonatomic) IBOutlet UILabel *editLab;
@property (weak, nonatomic) IBOutlet UIImageView *deleteImg;
@property (weak, nonatomic) IBOutlet UILabel *deleteLab;

@property (weak, nonatomic) IBOutlet UIButton *defaultBtn;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@end
