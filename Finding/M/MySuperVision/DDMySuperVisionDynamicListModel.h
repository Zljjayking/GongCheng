//
//  DDMySuperVisionDynamicListModel.h
//  GongChengDD
//
//  Created by xzx on 2018/12/1.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol LineSplitedModel <NSObject>
@end

@interface LineSplitedModel : JSONModel
@property (nonatomic,copy)NSString <Optional> *count;
@property (nonatomic,copy)NSString <Optional> *regionId;
@property (nonatomic,copy)NSString <Optional> *regionName;
@end

@interface RedirectParamMapModel : JSONModel
@property (nonatomic,copy)NSString <Optional> *record_id;
@property (nonatomic,copy)NSString <Optional> *cert_id;
@property (nonatomic,copy)NSString <Optional> *cert_type;
@property (nonatomic,copy)NSString <Optional> *enterprise_id;
@property (nonatomic,copy)NSString <Optional> *license_id;
@property (nonatomic,copy)NSString <Optional> *speciality_code;
@property (nonatomic,copy)NSString <Optional> *staff_info_id;
@property (nonatomic,copy)NSString <Optional> *region_id;
@end

@interface DDMySuperVisionDynamicListModel : JSONModel

/*
 createTime = "2018-12-01 08:52:47";
 entId = 16868;
 id = 2510;
 isDeleted = 0;
 isPacked = 0;
 isPushed = 1;
 isReaded = 0;
 lineA = "中建八局第三建设有限公司";
 lineB = "工商年报";
 lineC = "<font color="#3196fc">2019-06-30截止</font>";
 lineSplited = <null>;
 lineX = <null>;
 loopLineA = "中建八局第三建设有限公司";
 loopLineB = "工商年报 <font color="#3196fc">2019-06-30截止</font>";
 mainType = 1;
 pushTime = "2018-12-01 23:59:59";
 redirectParam = "license_id:179783;enterprise_id:16868";
 redirectParamMap = {
 enterprise_id = "16868"
 license_id = "179783";
 };
 rightTopInfo = <null>;
 subType = 1;
 typeCode = "ECE_001";
 updateTime = "2018-12-01 08:52:47";
 userId = 1379615402787072
 */

@property (nonatomic,copy)NSString <Optional> *createTime;
@property (nonatomic,copy)NSString <Optional> *entId;
@property (nonatomic,copy)NSString <Optional> *id;
@property (nonatomic,copy)NSString <Optional> *isDeleted;
@property (nonatomic,copy)NSString <Optional> *isPacked;
@property (nonatomic,copy)NSString <Optional> *isPushed;
@property (nonatomic,copy)NSString <Optional> *isReaded;
@property (nonatomic,copy)NSString <Optional> *lineA;
@property (nonatomic,copy)NSString <Optional> *lineB;
@property (nonatomic,copy)NSString <Optional> *lineC;
@property (nonatomic,copy)NSArray <Optional,LineSplitedModel> *lineSplited;
@property (nonatomic,copy)NSString <Optional> *lineX;
@property (nonatomic,copy)NSString <Optional> *loopLineA;
@property (nonatomic,copy)NSString <Optional> *loopLineB;
@property (nonatomic,copy)NSString <Optional> *mainType;
@property (nonatomic,copy)NSString <Optional> *pushTime;
@property (nonatomic,copy)NSString <Optional> *redirectParam;
@property (nonatomic,copy)RedirectParamMapModel <Optional> *redirectParamMap;
@property (nonatomic,copy)NSString <Optional> *rightTopInfo;
@property (nonatomic,copy)NSString <Optional> *subType;
@property (nonatomic,copy)NSString <Optional> *typeCode;
@property (nonatomic,copy)NSString <Optional> *updateTime;
@property (nonatomic,copy)NSString <Optional> *userId;
@property (nonatomic,copy)NSString <Optional> *in3Month;

@property (nonatomic, copy) NSAttributedString <Optional> *lineBString;
@property (nonatomic, copy) NSAttributedString <Optional> *lineCString;

-(void)handleModel;

@end

NS_ASSUME_NONNULL_END
