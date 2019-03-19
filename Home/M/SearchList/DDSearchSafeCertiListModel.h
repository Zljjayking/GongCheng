//
//  DDSearchSafeCertiListModel.h
//  GongChengDD
//
//  Created by xzx on 2018/9/19.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDSearchSafeCertiListModel : JSONModel
    
/*
 cert = "建筑装修装饰工程专业承包二级、建筑工程施工总承包三级";
 certTypeSource = <null>;
 enterpriseId = 82457;
 enterpriseName = <null>;
 flagList = <null>;
 flagstatus = "2";
 id = 82457;
 legalRepresentative = "陈平";
 mergerName = "江苏省,南京市";
 parentId = 320000
 phone = <null>;
 registerAddressSource = <null>;
 registerRegionId = 320100;
 staffInfoId = 1185062;
 status = "在业";
 taxNumber = <null>;
 unitName = "<font color='red'>南京</font>铁路建筑有限公司";
 usedNames = "<font color='red'>南京</font>铁路建筑公司";
 */
    @property (nonatomic, copy) NSString <Optional> *cert;
    @property (nonatomic, copy) NSString <Optional> *certTypeSource;
    @property (nonatomic, copy) NSString <Optional> *enterpriseId;
    @property (nonatomic, copy) NSString <Optional> *enterpriseName;
    @property (nonatomic, copy) NSString <Optional> *flagList;
    @property (nonatomic, copy) NSString <Optional> *flagstatus;
    @property (nonatomic, copy) NSString <Optional> *id;
    @property (nonatomic, copy) NSString <Optional> *legalRepresentative;
    @property (nonatomic, copy) NSString <Optional> *mergerName;
    @property (nonatomic, copy) NSString <Optional> *parentId;
    @property (nonatomic, copy) NSString <Optional> *phone;
    @property (nonatomic, copy) NSString <Optional> *registerAddressSource;
    @property (nonatomic, copy) NSString <Optional> *registerRegionId;
    @property (nonatomic, copy) NSString <Optional> *staffInfoId;
    @property (nonatomic, copy) NSString <Optional> *status;
    @property (nonatomic, copy) NSString <Optional> *taxNumber;
    @property (nonatomic, copy) NSString <Optional> *unitName;
    @property (nonatomic, copy) NSString <Optional> *usedNames;
    @property (nonatomic, copy) NSString <Optional> *validityPeriodEnd;
    
    
    @property (nonatomic, copy) NSAttributedString <Optional> *unitNameAttriStr;
    @property (nonatomic, copy) NSAttributedString <Optional> *peopleAttriString;
    
@end

NS_ASSUME_NONNULL_END
