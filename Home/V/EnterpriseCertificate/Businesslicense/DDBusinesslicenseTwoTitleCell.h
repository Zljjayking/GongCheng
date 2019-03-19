//
//  DDBusinesslicenseTwoTitleCell.h
//  GongChengDD
//
//  Created by csq on 2018/8/10.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDBusinesslicenseTwoTitleCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *ceterLine;
@property (weak, nonatomic) IBOutlet UILabel *leftTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *leftContentLab;

@property (weak, nonatomic) IBOutlet UILabel *rightLab;
@property (weak, nonatomic) IBOutlet UILabel *rightContentLab;


+ (CGFloat)height;

- (CGFloat)height;

@end
