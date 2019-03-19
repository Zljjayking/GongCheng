//
//  DDAddressManagerModel.h
//  GongChengDD
//
//  Created by xzx on 2018/7/5.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "JSONModel.h"

@interface DDAddressManagerModel : JSONModel

/*
 area = "雨花台区";
 city = "南京市";
 detail = "云密城K栋13层";
 history_address_id = 13;
 is_default = 1;
 province = "江苏省"
 receiver = "钢筋";
 tel = "15850529541";
 */
@property (nonatomic,copy) NSString <Optional> *province;
@property (nonatomic,copy) NSString <Optional> *city;
@property (nonatomic,copy) NSString <Optional> *area;
@property (nonatomic,copy) NSString <Optional> *detail;
@property (nonatomic,copy) NSString <Optional> *history_address_id;
@property (nonatomic,copy) NSString <Optional> *is_default;
@property (nonatomic,copy) NSString <Optional> *receiver;
@property (nonatomic,copy) NSString <Optional> *tel;

@end
