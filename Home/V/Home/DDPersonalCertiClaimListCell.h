//
//  DDPersonalCertiClaimListCell.h
//  GongChengDD
//
//  Created by xzx on 2018/12/1.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDSearchBuilderAndManagerListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDPersonalCertiClaimListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UIView *btnsView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tipsHeight;
@property (weak, nonatomic) IBOutlet UILabel *tipLab;
@property (weak, nonatomic) IBOutlet UIButton *claimBtn;

-(void)loadDataWithModel:(DDSearchBuilderAndManagerListModel *)model;
+(CGFloat)heightWithModel:(DDSearchBuilderAndManagerListModel *)model;

@end

NS_ASSUME_NONNULL_END
