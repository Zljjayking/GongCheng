//
//  DDTrainInputCompanyNameVC.h
//  GongChengDD
//
//  Created by xzx on 2018/7/19.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDSearchCompanyModel.h"//model

@interface DDTrainInputCompanyNameVC : UIViewController

@property (nonatomic,copy) void(^companyBlock)(NSString *companyName,NSString *companyId);

//type=1,代表从开局发票页面进来的 add by csq
@property (nonatomic,copy)NSString * type;

@property (nonatomic,strong) NSString *contentStr;

//选择完成block //add by csq
@property (nonatomic,copy) void(^finshBlock)(DDSearchCompanyModel*model);
@end
