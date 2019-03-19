//
//  DDSearchBusinessInfoListModel.h
//  GongChengDD
//
//  Created by xzx on 2018/9/19.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDSearchBusinessInfoListModel : JSONModel

    /*
     cert = <null>;
     certTypeSource = <null>;
     enterpriseId = 218918;
     enterpriseName = <null>;
     establishedDate = "1999-03-24";
     flagList = <null>;
     flagstatus = "2";
     id = 218918;
     legalRepresentative = "马建全";
     mergerName = <null>;
     parentId = <null>;
     phone = <null>;
     registerAddressSource = <null>;
     registerRegionId = <null>;
     staffInfoId = 3481935;
     status = "开业";
     taxNumber = <null>
     unitName = "榆林市自来水<font color='red'>公司</font>安装<font color='red'>公司</font>";
     usedNames = <null>;
     validityPeriodEnd = <null>;
     */
    
    @property (nonatomic, copy) NSString <Optional> *cert;
    @property (nonatomic, copy) NSString <Optional> *certTypeSource;
    @property (nonatomic, copy) NSString <Optional> *enterpriseId;
    @property (nonatomic, copy) NSString <Optional> *enterpriseName;
    @property (nonatomic, copy) NSString <Optional> *establishedDate;
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
    @property (nonatomic, copy) NSAttributedString <Optional> *usedNamesAttriString;
    
@end

NS_ASSUME_NONNULL_END
