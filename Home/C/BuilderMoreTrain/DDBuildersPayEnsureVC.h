//
//  DDBuildersPayEnsureVC.h
//  GongChengDD
//
//  Created by xzx on 2018/6/28.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDBuildersPayEnsureVC : UIViewController

@property (nonatomic,strong) NSString *userId;//被报名的人的Id
@property (nonatomic,strong) NSString *goodsId;//商品Id
@property (nonatomic,strong) NSString *trainId;//机构Id

@property (nonatomic,strong) NSString *certiTypeId;
@property (nonatomic,strong) NSString *certiId;

@property (nonatomic,strong) NSString *peopleName;
@property (nonatomic,strong) NSString *majorName;
@property (nonatomic,strong) NSString *agencyName;
@property (nonatomic,strong) NSString *majorPrice;
@property (nonatomic,strong) NSString *companyName;//企业名
@property (nonatomic,strong) NSString *vcName;
@property (nonatomic,strong) NSString *buildType; //主项 增项
/// isFromeAddApply = 1 表明是从“添加报名”按钮点进来的   0 表明是从“在线报名”按钮点进来的
@property (nonatomic, strong) NSString *isFromeAddApply;

@end
