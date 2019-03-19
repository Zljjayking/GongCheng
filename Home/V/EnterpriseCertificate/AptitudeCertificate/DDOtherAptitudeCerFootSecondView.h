//
//  DDOtherAptitudeCerFootSecondView.h
//  GongChengDD
//
//  Created by csq on 2018/8/29.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 其它资质foot,带"查看更多"按钮
 */
@interface DDOtherAptitudeCerFootSecondView : UIView
@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;
@property (weak, nonatomic) IBOutlet UILabel *topTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *topContentLab;

@property (weak, nonatomic) IBOutlet UILabel *centerTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *centerContentLab;


@property (weak, nonatomic) IBOutlet UILabel *bottomTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *bottomContentLab;

@property (weak, nonatomic) IBOutlet UILabel *timeLab;

+(CGFloat)height;
@end
