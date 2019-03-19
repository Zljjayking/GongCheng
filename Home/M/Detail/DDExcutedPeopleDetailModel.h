//
//  DDExcutedPeopleDetailModel.h
//  GongChengDD
//
//  Created by xzx on 2018/6/6.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface DDExcutedPeopleDetailGroupModel : JSONModel

/*
 executeCaseNumber = "(2018)冀1082执842号";
 executeCourt = "三河市人民法院";
 executeCreateDate = "2018-03-16 00:00:00";
 executeExplain = <null>;
 executeId = 4438967;
 executeOriginalHref = "http://zxgk.court.gov.cn/zhixing/new_index.html";
 executeOriginalImg = <null>
 executePerson = "三河市京新彩钢制品有限公司";
 executePersonCode = "91131082738****206U";
 executePersonType = <null>;
 executePublishDate = <null>;
 executeStandard = "4550000";
 isDiscredit = 0;
 legalRepresentative = <null>;
 regionId = 131082;
 */

@property (nonatomic,copy) NSString <Optional> *executeCaseNumber;
@property (nonatomic,copy) NSString <Optional> *executeCourt;
@property (nonatomic,copy) NSString <Optional> *executeCreateDate;
@property (nonatomic,copy) NSString <Optional> *executeExplain;
@property (nonatomic,copy) NSString <Optional> *executeId;
@property (nonatomic,copy) NSString <Optional> *executeOriginalHref;
@property (nonatomic,copy) NSString <Optional> *executeOriginalImg;
@property (nonatomic,copy) NSString <Optional> *executePerson;
@property (nonatomic,copy) NSString <Optional> *executePersonCode;
@property (nonatomic,copy) NSString <Optional> *executePersonType;
@property (nonatomic,copy) NSString <Optional> *executePublishDate;
@property (nonatomic,copy) NSString <Optional> *executeStandard;
@property (nonatomic,copy) NSString <Optional> *isDiscredit;
@property (nonatomic,copy) NSString <Optional> *legalRepresentative;
@property (nonatomic,copy) NSString <Optional> *regionId;

@end

@interface DDExcutedPeopleDetailModel : JSONModel

/*
 baseCourt = "北京市顺义区人民法院";
 baseNumber = "(2017)京0113民初22864号";
 duty = "因被执行人未履行生效法律文书确定的义务"
 executeCaseNumber = "(2018)京0113执3909号";
 executeCourt = "北京市顺义区人民法院";
 executeCreateDate = "2018-06-07";
 executeOriginalHref = "http://zxgk.court.gov.cn/detail?id=704013478";
 executePerson = "江苏康森迪信息科技有限公司";
 executePersonCode = "08287969-5";
 executePublishDate = "2018-07-19";
 executeStandard = <null>;
 legalRepresentative = "张亨德";
 performance = "全部未履行";
 province = "北京";
 */

@property (nonatomic,copy) NSString <Optional> *baseCourt;
@property (nonatomic,copy) NSString <Optional> *baseNumber;
@property (nonatomic,copy) NSString <Optional> *duty;
@property (nonatomic,copy) NSString <Optional> *executeCaseNumber;
@property (nonatomic,copy) NSString <Optional> *executeCourt;
@property (nonatomic,copy) NSString <Optional> *executeCreateDate;
@property (nonatomic,copy) NSString <Optional> *executeOriginalHref;
@property (nonatomic,copy) NSString <Optional> *executePerson;
@property (nonatomic,copy) NSString <Optional> *executePersonCode;
@property (nonatomic,copy) NSString <Optional> *executePublishDate;
@property (nonatomic,copy) NSString <Optional> *executeStandard;
@property (nonatomic,copy) NSString <Optional> *legalRepresentative;
@property (nonatomic,copy) NSString <Optional> *performance;
@property (nonatomic,copy) NSString <Optional> *province;
@property (nonatomic,copy) DDExcutedPeopleDetailGroupModel <Optional> *group;

@end
