//
//  DDPersonalClaimBenefitVC.h
//  GongChengDD
//
//  Created by xzx on 2018/12/8.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum:NSInteger{
    DDClaimBenefitTypeDefault = 0,//其他
    DDClaimBenefitTypeHomeList = 1,//首页个人认领
}DDClaimBenefitType;

NS_ASSUME_NONNULL_BEGIN

@interface DDPersonalClaimBenefitVC : UIViewController
@property(nonatomic,assign) DDClaimBenefitType claimBenefitType;

// 以下参数 当DDClaimBenefitTypeDefault 时需要传
@property (nonatomic,strong) NSString *peopleName;//人员姓名
@property (nonatomic,strong) NSString *peopleId;//人员Id
@end

NS_ASSUME_NONNULL_END
