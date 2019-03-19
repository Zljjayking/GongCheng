//
//  DDSafeManPayEnsureVC.h
//  GongChengDD
//
//  Created by xzx on 2018/7/14.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDSafeManPayEnsureVC : UIViewController

@property (nonatomic,strong) NSString *userId;//被报名的人的Id
@property (nonatomic,strong) NSString *goodsId;//商品Id
@property (nonatomic,strong) NSString *trainId;//机构Id

@property (nonatomic,strong) NSString *certiTypeId;
@property (nonatomic,strong) NSString *certiId;

@property (nonatomic,strong) NSString *certType;// 2 安全员新培 3安全员继续教育（手动添加）
@property (nonatomic,strong) NSString *peopleName;
@property (nonatomic,strong) NSString *majorName;
@property (nonatomic,strong) NSString *agencyName;
@property (nonatomic,strong) NSString *majorPrice;
@property (nonatomic,strong) NSString *companyName;
@property (nonatomic,strong) NSString *vcName;
/// isFromeAddApply = 1 表明是从添加报名按钮点进来的
@property (nonatomic, copy) NSString *isFromeAddApply;
@end
