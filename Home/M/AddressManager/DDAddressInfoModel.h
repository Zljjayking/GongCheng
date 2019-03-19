//
//  DDAddressInfoModel.h
//  GongChengDD
//
//  Created by xzx on 2018/7/17.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "JSONModel.h"

@interface DDAddressInfoModel : JSONModel

/*
 area = "雨花台区";
 city = "南京市";
 detail = "云密城K栋13层";
 history_address_id = 8;
 province = "江苏省"
 receiver = "董经川";
 tel = "13951624962";
 */

@property (nonatomic,copy) NSString <Optional> *area;
@property (nonatomic,copy) NSString <Optional> *city;
@property (nonatomic,copy) NSString <Optional> *detail;
@property (nonatomic,copy) NSString <Optional> *history_address_id;
@property (nonatomic,copy) NSString <Optional> *province;
@property (nonatomic,copy) NSString <Optional> *receiver;
@property (nonatomic,copy) NSString <Optional> *tel;

@end
