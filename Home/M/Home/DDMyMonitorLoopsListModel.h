//
//  DDMyMonitorLoopsListModel.h
//  GongChengDD
//
//  Created by xzx on 2018/12/4.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol LoopsLineSplitedModel <NSObject>
@end

@interface LoopsLineSplitedModel : JSONModel
@property (nonatomic,copy)NSString <Optional> *count;
@property (nonatomic,copy)NSString <Optional> *regionId;
@property (nonatomic,copy)NSString <Optional> *regionName;
@end

@interface LoopsRedirectParamMapModel : JSONModel
@property (nonatomic,copy)NSString <Optional> *cert_type;
@property (nonatomic,copy)NSString <Optional> *enterprise_id;
@property (nonatomic,copy)NSString <Optional> *license_id;
@property (nonatomic,copy)NSString <Optional> *speciality_code;
@property (nonatomic,copy)NSString <Optional> *staff_info_id;
@property (nonatomic,copy)NSString <Optional> *cert_id;
@property (nonatomic,copy)NSString <Optional> *record_id;
@end

@interface DDMyMonitorLoopsListModel : JSONModel

/*
 createTime = "2018-12-01 14:12:09";
 entId = <null>;
 id = 2606;
 in3Month = 0;
 isDeleted = 0;
 isPacked = 0;
 isPushed = 1;
 isReaded = 0;
 lineA = "李银寿";
 lineB = "二级建造师";
 lineC = "已变更至北京爱地鑫装饰艺术有限责任公司";
 lineSplited = <null>;
 lineX = <null>;
 loopLineA = "李银寿";
 loopLineB = "二级建造师已变更至北京爱地鑫装饰艺术有限责任公司";
 mainType = 5;
 pushTime = "2018-12-01 14:13:07";
 redirectParam = "enterprise_id:113216;cert_type:1;speciality_code:110003;staff_info_id:23236;";
 redirectParamMap = {
 cert_type = "1";
 enterprise_id = "113216";
 speciality_code = "110003";
 staff_info_id = "23236"
 };
 rightTopInfo = <null>;
 subType = 3;
 typeCode = "OTR_001";
 updateTime = "2018-12-01 14:12:09";
 userId = 1379615402787072
 */

@property (nonatomic,copy)NSString <Optional> *createTime;
@property (nonatomic,copy)NSString <Optional> *entId;
@property (nonatomic,copy)NSString <Optional> *id;
@property (nonatomic,copy)NSString <Optional> *in3Month;
@property (nonatomic,copy)NSString <Optional> *isDeleted;
@property (nonatomic,copy)NSString <Optional> *isPacked;
@property (nonatomic,copy)NSString <Optional> *isPushed;
@property (nonatomic,copy)NSString <Optional> *isReaded;
@property (nonatomic,copy)NSString <Optional> *lineA;
@property (nonatomic,copy)NSString <Optional> *lineB;
@property (nonatomic,copy)NSString <Optional> *lineC;
@property (nonatomic,copy)NSArray  <Optional,LoopsLineSplitedModel> *lineSplited;
@property (nonatomic,copy)NSString <Optional> *lineX;
@property (nonatomic,copy)NSString <Optional> *loopLineA;
@property (nonatomic,copy)NSString <Optional> *loopLineB;
@property (nonatomic,copy)NSString <Optional> *mainType;
@property (nonatomic,copy)NSString <Optional> *pushTime;
@property (nonatomic,copy)NSString <Optional> *redirectParam;
@property (nonatomic,copy)LoopsRedirectParamMapModel <Optional> *redirectParamMap;
@property (nonatomic,copy)NSString <Optional> *rightTopInfo;
@property (nonatomic,copy)NSString <Optional> *subType;
@property (nonatomic,copy)NSString <Optional> *typeCode;
@property (nonatomic,copy)NSString <Optional> *updateTime;
@property (nonatomic,copy)NSString <Optional> *userId;
@property (nonatomic,copy)NSString <Optional> *count;

@property (nonatomic, copy) NSAttributedString <Optional> *loopLineAString;
@property (nonatomic, copy) NSAttributedString <Optional> *loopLineBString;

-(void)handleModel;

@end


NS_ASSUME_NONNULL_END
