//
//  DDBrandDetailModel.h
//  GongChengDD
//
//  Created by csq on 2018/9/21.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

/**
 {
 code = 0
 data = {
 applicationDate = "2009-09-04 00:00:00";
 applicationFlow = <null>;
 brandImg = "http://tm-image.qichacha.com/89caa8e28b1fa0ebbe4b2475e1b7430b.jpg"
 brandName = "九状元";
 brandStatus = "商标转让中";
 brandType = "33-酒";
 brandUrl = "http://m.qichacha.com/brandDetail_ONTRPULQTRSL.html";
 bulletinNumber = "1228";
 bulletinTime = "2010-08-20 00:00:00";
 crawlTime = "2018-09-21 11:17:19";
 dataState = 1;
 endUseTime = "2020-11-20 00:00:00";
 enterpriseId = 1;
 enterpriseName = "一重集团大连工程建设有限公司";
 flows = [
 {
 content = "商标转让中";
 status = 0
 time = "2015-08-25";
 },
 {
 content = "商标变更完成";
 status = 0
 time = "2013-07-26";
 },
 {
 content = "变更商标申请人/注册人名义/地址中";
 status = 0
 time = "2013-06-04";
 },
 {
 content = "商标变更待审中";
 status = 0
 time = "2013-06-04";
 },
 {
 content = "商标转让完成";
 status = 0
 time = "2012-08-24";
 },
 {
 content = "商标转让待审中";
 status = 0
 time = "2012-01-17";
 },
 {
 content = "商标转让中";
 status = 0
 time = "2012-01-17";
 },
 {
 content = "商标已注册";
 status = 0
 time = "2010-12-10";
 },
 {
 content = "注册申请初步审定";
 status = 0
 time = "2010-07-07";
 },
 {
 content = "商标注册申请中";
 status = 0
 time = "2009-09-04";
 }
 ];
 proxyOrg = "广东邦信知识产权服务有限公司";
 registerId = "7673142";
 registerNumber = "1240";
 registerTime = "2010-08-20 00:00:00";
 serviceList = "果酒(含酒精)(3301);黄酒(3301);鸡尾酒(3301);酒(利口酒)(3301);蒸馏酒精饮料(3301);米酒(3301);苹果酒(3301);葡萄酒(3301);食用酒精(3301);开胃酒(3301)";
 startUseTime = "2010-11-21 00:00:00";
 updateTime = "2018-09-21 11:17:19";
 urlId = "001a547692729df1e17f6c6fb7d4217a";
 };
 msg = "success";
 }
 */
@protocol DDBrandDetailFlowsModel <NSObject>
@end
@interface DDBrandDetailFlowsModel : JSONModel
@property (nonatomic,copy) NSString<Optional> *content;
@property (nonatomic,copy) NSString<Optional> *status;
@property (nonatomic,copy) NSString<Optional> *time;
@end

//@protocol DDBrandDetailServicesModel <NSObject>
//@end
//@interface DDBrandDetailServicesModel : JSONModel
//
//@end

@interface DDBrandDetailModel : JSONModel
@property (nonatomic,copy) NSString<Optional> *applicationDate;
@property (nonatomic,copy) NSString<Optional> *applicationFlow;
@property (nonatomic,copy) NSString<Optional> *brandImg;
@property (nonatomic,copy) NSString<Optional> *brandName;
@property (nonatomic,copy) NSString<Optional> *brandStatus;
@property (nonatomic,copy) NSString<Optional> *brandType;
@property (nonatomic,copy) NSString<Optional> *brandUrl;
@property (nonatomic,copy) NSString<Optional> *bulletinNumber;//初审公告好
@property (nonatomic,copy) NSString<Optional> *bulletinTime;//s初审公告日期
@property (nonatomic,copy) NSString<Optional> *crawlTime;
@property (nonatomic,copy) NSString<Optional> *dataState;
@property (nonatomic,copy) NSString<Optional> *endUseTime;//使用时间结束
@property (nonatomic,copy) NSString<Optional> *enterpriseId;
@property (nonatomic,copy) NSString<Optional> *enterpriseName;
@property (nonatomic,copy) NSString<Optional> *proxyOrg;
@property (nonatomic,copy) NSString<Optional> *registerId;
@property (nonatomic,copy) NSString<Optional> *registerNumber;//注册公告号
@property (nonatomic,copy) NSString<Optional> *registerTime;//注册公告日期
@property (nonatomic,copy) NSString<Optional> *serviceList;
@property (nonatomic,copy) NSString<Optional> *startUseTime;//使用时间开始
@property (nonatomic,copy) NSString<Optional> *updateTime;
@property (nonatomic,copy) NSString<Optional> *urlId;
@property (nonatomic,copy) NSString<Optional> *address;
@property (nonatomic,copy) NSArray<Optional,DDBrandDetailFlowsModel> *flows;
@property (nonatomic,copy) NSArray<Optional>*services;
@end

NS_ASSUME_NONNULL_END
