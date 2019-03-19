//
//  DDPerfectPeopleInfoVC.h
//  GongChengDD
//
//  Created by xzx on 2018/7/24.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 二级建造师-完善人员信息
 */
@interface DDPerfectPeopleInfoVC : UIViewController


@property (nonatomic,strong) NSString *peopleName;//人员姓名
@property (nonatomic,strong) NSString *majorName;//专业名称
@property (nonatomic,strong) NSString *certiNo;//证书编号
@property (nonatomic,strong) NSString *haveB;//B类证情况,1有,其它无
@property (nonatomic,strong) NSString *endTime;//结束时间
@property (nonatomic,strong) NSString *formal;//临时,非临时
@property (nonatomic,strong) NSString *endDays;//结束天数
@property (nonatomic,strong) NSString *tel;//手机号(可选)

@property (nonatomic,strong) NSString *certType;//专业ID
//@property (nonatomic,strong) NSString *trainType;//培训类别 1二建继续教育 2安全员新培 3安全员继续教育 4现场施工新培 5现场施工继续教育 6二建继续教育补考 7安全员新培补考 8安全员继续教育补考 9现场施工新培补考 10现场施工继续教育补考

@property (nonatomic,strong) NSString *staffInfoId;//人员ID
@property (nonatomic,strong) NSString *certiTypeId;//专业ID

@property (nonatomic,strong) NSString *telAfter;//手机号打吗(可选)
@property (nonatomic,strong) NSString *idCard;//身份证(可选)
@property (nonatomic,strong) NSString *companyName;//企业名称

@end
