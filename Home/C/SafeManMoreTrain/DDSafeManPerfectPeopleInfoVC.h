//
//  DDSafeManPerfectPeopleInfoVC.h
//  GongChengDD
//
//  Created by xzx on 2018/7/25.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 安全员-完善人员信息
 */
@interface DDSafeManPerfectPeopleInfoVC : UIViewController

@property (nonatomic,strong) NSString *peopleName;
@property (nonatomic,strong) NSString *majorName;
@property (nonatomic,strong) NSString *certiNo;
@property (nonatomic,strong) NSString *certiState;
@property (nonatomic,strong) NSString *endTime;
@property (nonatomic,strong) NSString *endDays;
@property (nonatomic,strong) NSString *tel;

@property (nonatomic,strong) NSString *certType;//专业ID
//@property (nonatomic,strong) NSString *trainType;//培训类别 1二建继续教育 2安全员新培 3安全员继续教育 4现场施工新培 5现场施工继续教育 6二建继续教育补考 7安全员新培补考 8安全员继续教育补考 9现场施工新培补考 10现场施工继续教育补考

@property (nonatomic,strong) NSString *staffInfoId;//人员ID

@property (nonatomic,strong) NSString *certiTypeId;

@property (nonatomic,strong) NSString *telAfter;
@property (nonatomic,strong) NSString *idCard;
@property (nonatomic,strong) NSString *companyName;

@end
