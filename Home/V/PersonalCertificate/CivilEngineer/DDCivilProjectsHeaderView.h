//
//  DDCivilProjectsHeaderView.h
//  GongChengDD
//
//  Created by xzx on 2018/10/16.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDPersonalDetailInfoModel.h"//人员详情model

NS_ASSUME_NONNULL_BEGIN

@class DDCivilProjectsHeaderView;
@protocol DDCivilProjectsHeaderViewDelegate<NSObject>
@optional
- (void)checkBtnClick;
@end

@interface DDCivilProjectsHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *majorLab1;
@property (weak, nonatomic) IBOutlet UILabel *majorLab2;
@property (weak, nonatomic) IBOutlet UILabel *numberLab1;
@property (weak, nonatomic) IBOutlet UILabel *numberLab2;
@property (weak, nonatomic) IBOutlet UILabel *registerLab1;
@property (weak, nonatomic) IBOutlet UILabel *registerLab2;
@property (weak, nonatomic) IBOutlet UILabel *validLab1;
@property (weak, nonatomic) IBOutlet UILabel *validLab2;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@property (weak, nonatomic) id <DDCivilProjectsHeaderViewDelegate> delegate;
-(void)loadDataWithModel:(DDPersonalDetailInfoModel *)model;

@end

NS_ASSUME_NONNULL_END
