//
//  DDIndustryNews4Cell.h
//  GongChengDD
//
//  Created by xzx on 2018/5/10.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDIndustryNews4Cell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *attachLab1;
@property (weak, nonatomic) IBOutlet UILabel *attachLab2;
@property (weak, nonatomic) IBOutlet UILabel *attachLab3;

@property (weak, nonatomic) IBOutlet UILabel *tipLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftDistance;
@property (nonatomic, strong) NSString *titleStr;
@end
