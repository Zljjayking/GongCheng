//
//  DDBusinesslicenseModel.h
//  GongChengDD
//
//  Created by csq on 2017/11/30.
//  Copyright © 2017年 Koncendy. All rights reserved.
//

#import <JSONModel/JSONModel.h>
/*
 {
 code = 0
 data = {
 aicDeptId = <null>;
 branch = [
 {
 branchName = "测试"
 },
 {
 branchName = "测试"
 }
 ];
 businessDate = "1995-09-29 至 无固定期限"
 businessScope = "房屋建筑工程、公路、桥梁、线路、管道、设备安装工程、钢结构工程、土石方工程、建筑室内外装饰工程施工。(依法须经批准的项目,经相关部门批准后方可开展经营活动)";
 capital = "2060万人民币元";
 checkDate = "2016-04-20 00:00:00";
 checkInDeptSource = "沛县市场监督管理局";
 createdTime = "2018-07-19 17:09:35";
 createdUserId = 0;
 deleted = 0;
 economicType = 0;
 economicTypeSource = "全民所有制";
 email = "429324182@qq.com";
 enterpriseId = 56898;
 establishedDate = "1995-09-29 00:00:00";
 hosturl = "https://www.qichacha.com/firm_7385e68c1672c639af5c7554e21846f0.html";
 industry = "建筑业";
 legalRepresentative = "高绪东";
 licenseId = 563845;
 orgCode = "136865337";
 province = "江苏省";
 registerAddressSource = "沛县汤沐路";
 registerCapital = 20600000;
 registerCapitalCurrency = 0;
 registerNumber = "320322000000432";
 registerRegionAddress = <null>;
 registerRegionId = 320322;
 socialCreditCode = "913203221368653373";
 status = "在业";
 taxNumber = "913203221368653373";
 unitName = "江苏新联建筑公司";
 updatedTime = "2018-09-03 17:53:49";
 updatedUserId = 0;
 usedNames = <null>;
 validityPeriodEnd = "无固定期限";
 website = "";
 };
 msg = "success";
 }

 */

@protocol DDBusinesslicenseBranchModel <NSObject>
@end
@interface DDBusinesslicenseBranchModel : JSONModel
@property (nonatomic,copy) NSString<Optional> *branchName;
@end

@interface DDBusinesslicenseModel : JSONModel
@property (nonatomic,copy) NSString<Optional> *aicDeptId;
@property (nonatomic,copy) NSArray<Optional,DDBusinesslicenseBranchModel>*branch;//分支机构
@property (nonatomic,copy) NSString<Optional> *businessScope;//经营范围
@property (nonatomic,copy) NSString<Optional> *checkInDeptSource;//登记机关
@property (nonatomic,copy) NSString<Optional> *economicTypeSource;//企业类型
@property (nonatomic,copy) NSString<Optional> *establishedDate;//成立日期
@property (nonatomic,copy) NSString<Optional> *legalRepresentative;//法定代表人
@property (nonatomic,copy) NSString<Optional> *licenseId;
@property (nonatomic,copy) NSString<Optional> *registerCapital;//注册资本
@property (nonatomic,copy) NSString<Optional> *registerAddressSource;//住所
@property (nonatomic,copy) NSString<Optional> *socialCreditCode;//统一社会信用代码
@property (nonatomic,copy) NSString<Optional> *unitName;//名称
@property (nonatomic,copy) NSString<Optional> *validityPeriodEnd;//证书有效期,如果"无固定期限",直接显示,否则,计算下
@property (nonatomic,copy) NSString<Optional> *registerCapitalCurrency;//币种 0:人民币（元）  1:美元
@property (nonatomic,copy) NSString<Optional> *usedNames;//曾用名
@property (nonatomic,copy) NSString<Optional> *status;//经营状态
@property (nonatomic,copy) NSString<Optional> *industry;//所属行业
@property (nonatomic,copy) NSString<Optional> *businessDate;//经营期限
@property (nonatomic,copy) NSString<Optional> *checkDate;//核准日期
@property (nonatomic,copy) NSString<Optional> *hasChange;//是否有变更记录,0没有 1有

//以下是自定义字段
@property (nonatomic,assign)NSNumber<Optional> *showMoreButton;//是否需要显示"更多按钮"
@property (nonatomic,assign)NSNumber<Optional> *showAllMangerRange;//是否完全显示"经营范围"
@property (nonatomic,assign)NSNumber<Optional> *showRegisterInfo;//是否显示"登记信息"
@property (nonatomic,assign)NSNumber<Optional> *showBranch;//是否显示"分支机构"

//处理数据
- (void)handleData;

@end
