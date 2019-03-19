//
//  DDSearchRecordModel.h
//  GongChengDD
//
//  Created by xzx on 2018/5/22.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface DDSearchRecordModel : JSONModel

@property (nonatomic, copy) NSString <Optional> *title;
@property (nonatomic, copy) NSString <Optional> *globalType;//全局搜索时区分企业，人员和项目用的，分别为0，1，2
@property (nonatomic, copy) NSString <Optional> *transId;//跳转到企业，人员，项目详情页面时需要

@end
