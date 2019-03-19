//
//  DDPersonalIdentityCheckVC.h
//  GongChengDD
//
//  Created by xzx on 2018/9/26.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDSearchBuilderAndManagerListModel.h"

typedef enum:NSInteger {
    DDIdentityCheckTypeDefault=0,
    DDIdentityCheckTypeHomeList=1,
}DDIdentityCheckType;

NS_ASSUME_NONNULL_BEGIN

@interface DDPersonalIdentityCheckVC : UIViewController

@property(nonatomic,assign) DDIdentityCheckType identityCheckType;
//在DDIdentityCheckTypeDefault 传model
@property (nonatomic,strong) NSString *peopleName;//人员姓名
@property (nonatomic,strong) NSString *staffInfoId;//人员Id
//在DDIdentityCheckTypeHomeList 传model
@property (nonatomic,strong)DDSearchBuilderAndManagerListModel *model;

@end

NS_ASSUME_NONNULL_END
