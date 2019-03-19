//
//  DDFindingConditionModel.h
//  GongChengDD
//
//  Created by csq on 2018/11/6.
//  Copyright © 2018 Koncendy. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDFindingConditionModel : JSONModel
@property (nonatomic,copy)NSString <Optional> *region;//公司所在地id
@property (nonatomic,copy)NSString <Optional> *regionName;//公司所在地名称

@property (nonatomic,copy)NSString <Optional> *certTypeId;//资质类别
@property (nonatomic,copy)NSString <Optional> *certTypeLevel;//资质等级

@property (nonatomic,copy)NSString <Optional> *certType;//企业人员证书
@property (nonatomic,copy)NSString <Optional> *certTypeCustomName;//企业人员证书name
@property (nonatomic,assign)NSInteger pointRow;//之前已经选中的企业人员证书行

@property (nonatomic,copy)NSString <Optional> *certCode;//企业人员code

@property (nonatomic,copy)NSString <Optional> *bidTime;//项目时间
@property (nonatomic,copy)NSString <Optional> *bidTimeName;//项目时间

@property (nonatomic,copy)NSString <Optional> *bidRegion;//项目地区id
@property (nonatomic,copy)NSString <Optional> *bidRegionName;//项目地区名称

@property (nonatomic,copy)NSString <Optional> *minMoney;//中标金额
@property (nonatomic,copy)NSString <Optional> *maxMoney;//中标金额

@property (nonatomic,copy)NSString <Optional> *title;//项目名称

//自定义字段
@property (nonatomic,copy)NSNumber <Optional> *canAction;//YES"查找"按钮可点,NO不可点
@property (nonatomic,copy)NSString <Optional> *certTypeName;//资质类别名称
@end

NS_ASSUME_NONNULL_END
