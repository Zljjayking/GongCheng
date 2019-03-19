//
//  DDAptitudeCertiListModel.h
//  GongChengDD
//
//  Created by xzx on 2018/12/11.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol DDAptitudeContent <NSObject>
@end
@interface DDAptitudeContent : JSONModel
@property (nonatomic,copy)NSString <Optional> *cert;
@property (nonatomic,copy)NSString <Optional> *certNo;
@property (nonatomic,copy)NSString <Optional> *certTypeId;
@property (nonatomic,copy)NSString <Optional> *issuedDate;
@property (nonatomic,copy)NSString <Optional> *issuedDeptSource;
@property (nonatomic,copy)NSString <Optional> *name;
@property (nonatomic,copy)NSString <Optional> *qualificationCertificateId;
@property (nonatomic,copy)NSString <Optional> *type;
@property (nonatomic,copy)NSString <Optional> *validityPeriodEnd;
@property (nonatomic,copy)NSString <Optional> *majorCategory;
@end

@protocol DDAptitudeList <NSObject>
@end
@interface DDAptitudeList : JSONModel
@property (nonatomic,copy)NSString <Optional> *certName;
@property (nonatomic,copy)NSArray <Optional,DDAptitudeContent> *content;
@end

@interface DDAptitudeCertiListModel : JSONModel

/*
 enterpriseName = "南京龙腾建设有限公司";
 list = [
    {
        certName = "建筑业企业资质"
        content = [
                    {
                        cert = "2";
                        certNo = "D232016419";
                        certTypeId = "220101";
                        issuedDate = "2018-09-03";
                        issuedDeptSource = "江苏省住房和城乡建设厅";
                        name = "建筑业企业资质"
                        qualificationCertificateId = 1373199634904524;
                        type = 0;
                        validityPeriodEnd = "2020-11-30";
                    }
                ];
    }
 ];
 subitemCount = 1
 */

@property (nonatomic,copy)NSString <Optional> *enterpriseName;
@property (nonatomic,copy)NSArray <Optional,DDAptitudeList> *list;
@property (nonatomic,copy)NSString <Optional> *subitemCount;

@end

NS_ASSUME_NONNULL_END
