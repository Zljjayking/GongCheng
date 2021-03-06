//
//  DDBuildersAndAgencyVC.h
//  GongChengDD
//
//  Created by xzx on 2018/6/28.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDBuildersAndAgencyVC : UIViewController

@property (nonatomic,strong) NSString *peopleName;
@property (nonatomic,strong) NSString *majorName;
@property (nonatomic,strong) NSString *certiNo;
@property (nonatomic,strong) NSString *haveB;
@property (nonatomic,strong) NSString *endTime;
@property (nonatomic,strong) NSString *formal;
@property (nonatomic,strong) NSString *endDays;
@property (nonatomic,strong) NSString *tel;


@property (nonatomic,strong) NSString *agencyName;
@property (nonatomic,strong) NSString *address;
@property (nonatomic,strong) NSString *majorPrice;
@property (nonatomic,strong) NSString *price;
@property (nonatomic,strong) NSString *introduce;
@property (nonatomic,strong) NSString *explain;

@property (nonatomic,strong) NSString *userId;//被报名的人的Id
@property (nonatomic,strong) NSString *goodsId;//商品Id
@property (nonatomic,strong) NSString *trainId;//机构Id

@property (nonatomic,strong) NSString *certiTypeId;

@property (nonatomic,strong) NSString *idCard;
@property (nonatomic,strong) NSString *companyName;
@property (nonatomic,strong) NSString *companyId;

@property (nonatomic,strong) NSString *staffId;

/// isFromeAddApply = 1 表明是从“添加报名”按钮点进来的   0 表明是从“在线报名”按钮点进来的
@property (nonatomic, strong) NSString *isFromeAddApply;

@end
