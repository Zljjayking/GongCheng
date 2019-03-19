//
//  DDReceivedProjectsHeaderView.h
//  GongChengDD
//
//  Created by xzx on 2018/9/28.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDPersonalDetailInfoModel.h"//人员详情model

NS_ASSUME_NONNULL_BEGIN

@class DDReceivedProjectsHeaderView;
@protocol DDReceivedProjectsHeaderViewDelegate<NSObject>
@optional
- (void)checkBtnClick;
@end

@interface DDReceivedProjectsHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *majorLab1;
@property (weak, nonatomic) IBOutlet UILabel *majorLab2;
@property (weak, nonatomic) IBOutlet UILabel *numberLab1;
@property (weak, nonatomic) IBOutlet UILabel *numberLab2;
@property (weak, nonatomic) IBOutlet UILabel *registerLab1;
@property (weak, nonatomic) IBOutlet UILabel *registerLab2;
@property (weak, nonatomic) IBOutlet UILabel *hasBLab1;
@property (weak, nonatomic) IBOutlet UILabel *hasBLab2;
@property (weak, nonatomic) IBOutlet UILabel *validLab1;
@property (weak, nonatomic) IBOutlet UILabel *validLab2;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@property (weak, nonatomic) id <DDReceivedProjectsHeaderViewDelegate> delegate;
-(void)loadDataWithModel:(DDPersonalDetailInfoModel *)model;

@end

NS_ASSUME_NONNULL_END
