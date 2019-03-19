//
//  DDGetPayAddressInfoModel.h
//  GongChengDD
//
//  Created by xzx on 2018/7/18.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "JSONModel.h"

@interface DDGetPayAddressInfoModel : JSONModel

/*
 area = "";
 city = "";
 detail = "";
 history_address_id = <null>;
 postage = <null>;
 province = ""
 receiver = "";
 tel = "";
 */

@property (nonatomic,copy) NSString <Optional> *area;
@property (nonatomic,copy) NSString <Optional> *city;
@property (nonatomic,copy) NSString <Optional> *detail;
@property (nonatomic,copy) NSString <Optional> *history_address_id;
@property (nonatomic,copy) NSString <Optional> *postage;
@property (nonatomic,copy) NSString <Optional> *province;
@property (nonatomic,copy) NSString <Optional> *receiver;
@property (nonatomic,copy) NSString <Optional> *tel;

@end
