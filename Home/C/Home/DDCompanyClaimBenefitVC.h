//
//  DDCompanyClaimBenefitVC.h
//  GongChengDD
//
//  Created by xzx on 2018/12/8.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum: NSInteger{
    CompanyClaimBenefitTypeDefault=0, //不带公司
    CompanyClaimBenefitTypeCompany=1, //带公司
}DDCompanyClaimBenefitType;

NS_ASSUME_NONNULL_BEGIN

@interface DDCompanyClaimBenefitVC : UIViewController
@property(nonatomic,assign) DDCompanyClaimBenefitType companyClaimBenefitType;
/**
 YES:从"我的"页面来,NO:从其他页面进来
 */
@property (nonatomic,assign)BOOL isFromMyInfo;

//company
@property(nonatomic,strong)NSString *companyid;  //企业id
@property(nonatomic,strong)NSString *companyName; //企业名

@end

NS_ASSUME_NONNULL_END
