//
//  DDBuyCompanyDetail2Cell.h
//  GongChengDD
//
//  Created by xzx on 2018/5/30.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDBuyCompanyDetailModel.h"

@protocol DDBuyCompanyDetail2CellDelegate <NSObject>
@optional
-(void)downOrUpBtnClick;
@end


@interface DDBuyCompanyDetail2Cell : UITableViewCell

@property (assign,nonatomic) NSString *status;//0表示收起只显示5条，1表示展开有多少显示多少
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *lineLab;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewHeight;
@property (nonatomic,weak) id<DDBuyCompanyDetail2CellDelegate> delegate;

-(void)loadWithArray:(NSArray *)array;

@end
