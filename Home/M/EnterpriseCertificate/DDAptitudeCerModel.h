//
//  DDAptitudeCerModel.h
//  GongChengDD
//
//  Created by csq on 2018/5/25.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <JSONModel/JSONModel.h>
/*
 {
 code = 0
 data = {
 list = [
 {
 certNo = "D232058741";
 class = "com.koncendy.modules.certificate.entity.EcQualificationEntity"
 createdTime = "2018-07-20 19:09:57";
 createdUserId = 0;
 deleted = 0;
 enterpriseId = 40648;
 issueDeptLevel = 0;
 issuedDate = "2018-05-29 00:00:00";
 issuedDeptId = <null>;
 issuedDeptSource = "江苏省住房和城乡建设厅";
 qualificationCertificateId = 41226;
 subitem = [
 {
 approvalDate = "2018-05-29 00:00:00";
 certTypeId = "220102";
 certTypeLevel = "2";
 certTypeSource = "公路工程施工总承包二级";
 certificateSequence = <null>;
 certificateSequenceSource = <null>;
 class = "com.koncendy.modules.certificate.entity.EcQualificationSubitemEntity";
 createdTime = "2018-07-20 19:09:57";
 createdUserId = 0;
 deleted = 0;
 makeWay = <null>;
 makeWaySource = <null>;
 qualificationCertificateId = 41226;
 qualificationSubitemId = 76311;
 status = <null>
 updatedTime = "2018-08-24 02:01:32";
 updatedUserId = 0;
 },
 {
 approvalDate = "2018-05-29 00:00:00";
 certTypeId = "220103";
 certTypeLevel = "3";
 certTypeSource = "铁路工程施工总承包三级";
 certificateSequence = <null>;
 certificateSequenceSource = <null>;
 class = "com.koncendy.modules.certificate.entity.EcQualificationSubitemEntity";
 createdTime = "2018-07-20 19:10:10";
 createdUserId = 0;
 deleted = 0;
 makeWay = <null>;
 makeWaySource = <null>;
 qualificationCertificateId = 41226;
 qualificationSubitemId = 76430;
 status = <null>
 updatedTime = "2018-08-24 02:01:32";
 updatedUserId = 0;
 },
 {
 approvalDate = "2018-05-29 00:00:00";
 certTypeId = "220112";
 certTypeLevel = "2";
 certTypeSource = "机电工程施工总承包二级";
 certificateSequence = <null>;
 certificateSequenceSource = <null>;
 class = "com.koncendy.modules.certificate.entity.EcQualificationSubitemEntity";
 createdTime = "2018-07-20 19:10:02";
 createdUserId = 0;
 deleted = 0;
 makeWay = <null>;
 makeWaySource = <null>;
 qualificationCertificateId = 41226;
 qualificationSubitemId = 76370;
 status = <null>
 updatedTime = "2018-08-24 02:01:32";
 updatedUserId = 0;
 },
 {
 approvalDate = "2018-05-29 00:00:00";
 certTypeId = "220201";
 certTypeLevel = "2";
 certTypeSource = "地基基础工程专业承包二级";
 certificateSequence = <null>;
 certificateSequenceSource = <null>;
 class = "com.koncendy.modules.certificate.entity.EcQualificationSubitemEntity";
 createdTime = "2018-07-20 19:10:33";
 createdUserId = 0;
 deleted = 0;
 makeWay = <null>;
 makeWaySource = <null>;
 qualificationCertificateId = 41226;
 qualificationSubitemId = 76620;
 status = <null>
 updatedTime = "2018-08-24 02:01:33";
 updatedUserId = 0;
 },
 {
 approvalDate = "2018-05-29 00:00:00";
 certTypeId = "220205";
 certTypeLevel = "2";
 certTypeSource = "消防设施工程专业承包二级";
 certificateSequence = <null>;
 certificateSequenceSource = <null>;
 class = "com.koncendy.modules.certificate.entity.EcQualificationSubitemEntity";
 createdTime = "2018-07-20 19:10:40";
 createdUserId = 0;
 deleted = 0;
 makeWay = <null>;
 makeWaySource = <null>;
 qualificationCertificateId = 41226;
 qualificationSubitemId = 76685;
 status = <null>
 updatedTime = "2018-08-24 02:01:33";
 updatedUserId = 0;
 },
 {
 approvalDate = "2018-05-29 00:00:00";
 certTypeId = "220211";
 certTypeLevel = "1";
 certTypeSource = "建筑装修装饰工程专业承包一级";
 certificateSequence = <null>;
 certificateSequenceSource = <null>;
 class = "com.koncendy.modules.certificate.entity.EcQualificationSubitemEntity";
 createdTime = "2018-07-20 19:10:18";
 createdUserId = 0;
 deleted = 0;
 makeWay = <null>;
 makeWaySource = <null>;
 qualificationCertificateId = 41226;
 qualificationSubitemId = 76491;
 status = <null>
 updatedTime = "2018-08-24 02:01:33";
 updatedUserId = 0;
 },
 {
 approvalDate = "2018-05-29 00:00:00";
 certTypeId = "220212";
 certTypeLevel = "1";
 certTypeSource = "建筑机电安装工程专业承包一级";
 certificateSequence = <null>;
 certificateSequenceSource = <null>;
 class = "com.koncendy.modules.certificate.entity.EcQualificationSubitemEntity";
 createdTime = "2018-07-20 19:10:26";
 createdUserId = 0;
 deleted = 0;
 makeWay = <null>;
 makeWaySource = <null>;
 qualificationCertificateId = 41226;
 qualificationSubitemId = 76556;
 status = <null>
 updatedTime = "2018-08-24 02:01:33";
 updatedUserId = 0;
 }
 ];
 updatedTime = "2018-08-24 02:01:33";
 updatedUserId = 0;
 validityPeriodEnd = "2021-01-08 00:00:00";
 },
 {
 certNo = "D132039134";
 class = "com.koncendy.modules.certificate.entity.EcQualificationEntity"
 createdTime = "2018-07-20 19:09:39";
 createdUserId = 0;
 deleted = 0;
 enterpriseId = 40648;
 issueDeptLevel = 0;
 issuedDate = "2018-06-04 00:00:00";
 issuedDeptId = <null>;
 issuedDeptSource = "住房和城乡建设部";
 qualificationCertificateId = 41146;
 subitem = [
 {
 approvalDate = "2018-06-04 00:00:00";
 certTypeId = "220101";
 certTypeLevel = "0";
 certTypeSource = "建筑工程施工总承包特级";
 certificateSequence = <null>;
 certificateSequenceSource = <null>;
 class = "com.koncendy.modules.certificate.entity.EcQualificationSubitemEntity";
 createdTime = "2018-07-20 19:09:52";
 createdUserId = 0;
 deleted = 0;
 makeWay = <null>;
 makeWaySource = <null>;
 qualificationCertificateId = 41146;
 qualificationSubitemId = 76263;
 status = <null>
 updatedTime = "2018-08-24 02:01:32";
 updatedUserId = 0;
 },
 {
 approvalDate = "2018-06-04 00:00:00";
 certTypeId = "220110";
 certTypeLevel = "1";
 certTypeSource = "市政公用工程施工总承包一级";
 certificateSequence = <null>;
 certificateSequenceSource = <null>;
 class = "com.koncendy.modules.certificate.entity.EcQualificationSubitemEntity";
 createdTime = "2018-07-20 19:09:39";
 createdUserId = 0;
 deleted = 0;
 makeWay = <null>;
 makeWaySource = <null>;
 qualificationCertificateId = 41146;
 qualificationSubitemId = 76139;
 status = <null>
 updatedTime = "2018-08-24 02:01:31";
 updatedUserId = 0;
 },
 {
 approvalDate = "2018-06-04 00:00:00";
 certTypeId = "220209";
 certTypeLevel = "1";
 certTypeSource = "钢结构工程专业承包一级";
 certificateSequence = <null>;
 certificateSequenceSource = <null>;
 class = "com.koncendy.modules.certificate.entity.EcQualificationSubitemEntity";
 createdTime = "2018-07-20 19:09:45";
 createdUserId = 0;
 deleted = 0;
 makeWay = <null>;
 makeWaySource = <null>;
 qualificationCertificateId = 41146;
 qualificationSubitemId = 76202;
 status = <null>
 updatedTime = "2018-08-24 02:01:32";
 updatedUserId = 0;
 }
 ];
 updatedTime = "2018-08-24 02:01:32";
 updatedUserId = 0;
 validityPeriodEnd = "2021-02-01 00:00:00";
 },
 {
 certNo = "D332084524";
 class = "com.koncendy.modules.certificate.entity.EcQualificationEntity"
 createdTime = "2018-07-20 19:10:50";
 createdUserId = 0;
 deleted = 0;
 enterpriseId = 40648;
 issueDeptLevel = 0;
 issuedDate = "2018-05-24 00:00:00";
 issuedDeptId = <null>;
 issuedDeptSource = "南通市城乡建设局";
 qualificationCertificateId = 41407;
 subitem = [
 {
 approvalDate = "2018-05-24 00:00:00";
 certTypeId = "220105";
 certTypeLevel = "3";
 certTypeSource = "水利水电工程施工总承包三级";
 certificateSequence = <null>;
 certificateSequenceSource = <null>;
 class = "com.koncendy.modules.certificate.entity.EcQualificationSubitemEntity";
 createdTime = "2018-07-20 19:10:50";
 createdUserId = 0;
 deleted = 0;
 makeWay = <null>;
 makeWaySource = <null>;
 qualificationCertificateId = 41407;
 qualificationSubitemId = 76741;
 status = <null>
 updatedTime = "2018-08-24 02:01:33";
 updatedUserId = 0;
 }
 ];
 updatedTime = "2018-08-24 02:01:33";
 updatedUserId = 0;
 validityPeriodEnd = "2021-03-07 00:00:00";
 }
 ];
 subitemCount = 11
 };
 msg = "success";
 }

 */

@protocol DDSubitemModel <NSObject>
@end
@interface DDSubitemModel : JSONModel
@property (nonatomic,copy)NSString <Optional> *approvalDate;//批准时间
@property (nonatomic,copy)NSString <Optional> *certTypeId;//证书种类id 开头2204是电力资质
@property (nonatomic,copy)NSString <Optional> *certTypeLevel;//证书级别,1对应一级
@property (nonatomic,copy)NSString <Optional> *certTypeSource;
@property (nonatomic,copy)NSString <Optional> *certificateSequence;
@property (nonatomic,copy)NSString <Optional> *certificateSequenceSource;
@property (nonatomic,copy)NSString <Optional> *createdTime;
@property (nonatomic,copy)NSString <Optional> *createdUserId;
@property (nonatomic,copy)NSString <Optional> *deleted;
@property (nonatomic,copy)NSString <Optional> *makeWay;
@property (nonatomic,copy)NSString <Optional> *makeWaySource;
@property (nonatomic,copy)NSString <Optional> *qualificationCertificateId;
@property (nonatomic,copy)NSString <Optional> *qualificationSubitemId;
@property (nonatomic,copy)NSString <Optional> *updatedTime;
@property (nonatomic,copy)NSString <Optional> *updatedUserId;
@property (nonatomic,copy)NSString <Optional> *status;//如果为null,是其它资质,否则,是电力资质(过期,有效)
@end


@interface DDAptitudeCerModel : JSONModel
@property (nonatomic,copy)NSString <Optional> *certNo;//证书编号
@property (nonatomic,copy)NSString <Optional> *certTypeName;//资质类别
@property (nonatomic,copy)NSString <Optional> *createdTime;
@property (nonatomic,copy)NSString <Optional> *createdUserId;
@property (nonatomic,copy)NSString <Optional> *deleted;
@property (nonatomic,copy)NSString <Optional> *enterpriseId;
@property (nonatomic,copy)NSString <Optional> *issueDeptLevel;
@property (nonatomic,copy)NSString <Optional> *issuedDate;//发证日期
@property (nonatomic,copy)NSString <Optional> *issuedDeptId;
@property (nonatomic,copy)NSString <Optional> *issuedDeptSource;//部门
@property (nonatomic,copy)NSString <Optional> *qualificationCertificateId;
@property (nonatomic,copy)NSArray <Optional,DDSubitemModel> *subitem;//证书级别数组
@property (nonatomic,copy)NSString <Optional> *updatedTime;
@property (nonatomic,copy)NSString <Optional> *updatedUserId;
@property (nonatomic,copy)NSString <Optional> *validityPeriodEnd;//到期时间
@property (nonatomic,copy)NSString <Optional> *majorCategory;//1详情只有一个标题,2,3以此类推
@property (nonatomic,copy)NSString <Optional> *type;// 1电力资质  0不是


//以下是自定义字段
@property (nonatomic,assign)NSNumber <Optional> *showAllItems;//是否展示全部条目,
@property (nonatomic,assign)NSNumber <Optional> *showMoreButton;//是否显示"查看更多"按钮
//处理数据
- (void)handleData;

@end
