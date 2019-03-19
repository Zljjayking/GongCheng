//
//  DDSearchTelephoneListModel.h
//  GongChengDD
//
//  Created by xzx on 2018/6/13.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface DDSearchTelephoneListModel : JSONModel

/*
 cert = <null>;
 enterpriseId = 1371047573160192;
 enterpriseName = <null>;
 flagList = <null>
 id = 1371047573160192;
 legalRepresentative = "李延明";
 mergerName = <null>;
 parentId = <null>;
 registerRegionId = <null>;
 tel = <null>;
 unitName = "南京延明体育实业有限<font color='red'>公司</font>";
 */

@property (nonatomic, copy) NSString <Optional> *cert;
@property (nonatomic, copy) NSString <Optional> *enterpriseId;
@property (nonatomic, copy) NSString <Optional> *enterpriseName;
@property (nonatomic, copy) NSString <Optional> *flagList;
@property (nonatomic, copy) NSString <Optional> *id;
@property (nonatomic, copy) NSString <Optional> *legalRepresentative;
@property (nonatomic, copy) NSString <Optional> *mergerName;
@property (nonatomic, copy) NSString <Optional> *parentId;
@property (nonatomic, copy) NSString <Optional> *registerRegionId;
@property (nonatomic, copy) NSString <Optional> *phone;
@property (nonatomic, copy) NSString <Optional> *unitName;

@property (nonatomic, copy) NSAttributedString <Optional> *enterpriseNameStr;
@property (nonatomic, copy) NSAttributedString <Optional> *peopleNameStr;

@end
