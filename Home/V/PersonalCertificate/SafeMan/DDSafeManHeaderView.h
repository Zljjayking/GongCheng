//
//  DDSafeManHeaderView.h
//  GongChengDD
//
//  Created by csq on 2018/7/31.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DDSafeManHeaderView;
@protocol DDSafeManHeaderViewDelegate<NSObject>
@optional
//在线报名
- (void)safeManHeaderViewClickSignUp:(DDSafeManHeaderView*)safeManHeaderView;
@end

@interface DDSafeManHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *residueDaysBgView;//剩余天数背景View
@property (weak, nonatomic) IBOutlet UILabel *specialityMarkLab;
@property (weak, nonatomic) IBOutlet UILabel *specialityLab;
@property (weak, nonatomic) IBOutlet UILabel *certNoMarkLab;
@property (weak, nonatomic) IBOutlet UILabel *certNoLab;
//@property (weak, nonatomic) IBOutlet UILabel *hasBCerMarkLab;
//@property (weak, nonatomic) IBOutlet UILabel *hasBCerLab;
@property (weak, nonatomic) IBOutlet UILabel *validityMarkLab;
@property (weak, nonatomic) IBOutlet UILabel *validityLab;
@property (weak, nonatomic) IBOutlet UILabel *signUpLab;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet UIImageView *residueBgImageView;
@property (weak, nonatomic) IBOutlet UILabel *residueMarkLab;
@property (weak, nonatomic) IBOutlet UILabel *residueDayLab;
@property (weak, nonatomic)id<DDSafeManHeaderViewDelegate>delegate;

@end
