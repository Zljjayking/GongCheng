//
//  DDNearCompanyCell.h
//  GongChengDD
//
//  Created by csq on 2018/10/19.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDNearCompanyModel.h"

@class DDNearCompanyCell;
@protocol DDNearCompanyCellDelegate <NSObject>
@optional
//点击了地址
- (void)adressLabClick:(DDNearCompanyCell*)nearCompanyCell;

@end

NS_ASSUME_NONNULL_BEGIN

@interface DDNearCompanyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *companyName;
@property (weak, nonatomic) IBOutlet UIView *statesBgView;
@property (weak, nonatomic) IBOutlet UILabel *statesLab;
@property (weak, nonatomic) IBOutlet UILabel *redisterCaptalLab;
@property (weak, nonatomic) IBOutlet UILabel *certLab;
@property (weak, nonatomic) IBOutlet UILabel *distanceLab;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;
@property (weak, nonatomic) IBOutlet UIView *adressBgView;
@property (weak, nonatomic) IBOutlet UIImageView *adressImageView;
@property (weak, nonatomic) IBOutlet UILabel *adressLab;
@property (weak, nonatomic) IBOutlet UIImageView *arrow;
@property (weak, nonatomic) id<DDNearCompanyCellDelegate>delegate;

- (void)loadWithModel:(DDNearCompanyResultModel*)model;

+(CGFloat)height;

@end

NS_ASSUME_NONNULL_END
