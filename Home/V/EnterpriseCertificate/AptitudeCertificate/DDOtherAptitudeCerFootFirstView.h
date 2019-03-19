//
//  DDOtherAptitudeCerFootFirstView.h
//  GongChengDD
//
//  Created by csq on 2018/8/29.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
其它资质foot,不带不带"查看更多"按钮
 */
@interface DDOtherAptitudeCerFootFirstView : UIView
@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet UILabel *topTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *topContentLab;

@property (weak, nonatomic) IBOutlet UILabel *centerTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *centerContentLab;

@property (weak, nonatomic) IBOutlet UILabel *bottomTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *bottomContentLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

+(CGFloat)height;

@end
