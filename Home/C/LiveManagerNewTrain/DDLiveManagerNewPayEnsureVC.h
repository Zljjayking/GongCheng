//
//  DDLiveManagerNewPayEnsureVC.h
//  GongChengDD
//
//  Created by xzx on 2018/7/26.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDLiveManagerNewPayEnsureVC : UIViewController

@property (nonatomic,strong) NSString *userId;//被报名的人的Id
@property (nonatomic,strong) NSString *goodsId;//商品Id
@property (nonatomic,strong) NSString *trainId;//机构Id

@property (nonatomic,strong) NSString *certiTypeId;
@property (nonatomic,strong) NSString *certiId;

@property (nonatomic,strong) NSString *peopleName;
@property (nonatomic,strong) NSString *majorName;
@property (nonatomic,strong) NSString *agencyName;
@property (nonatomic,strong) NSString *majorPrice;

@end
