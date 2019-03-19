//
//  DDManageDetailModel.h
//  GongChengDD
//
//  Created by csq on 2018/9/19.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

/**
 {
 code = 0
 data = {
 authAgainTimes = "0";
 authCoverAddressName = "None";
 authProject = "中国职业健康安全管理体系认证";
 authRange = "资质范围内市政公用工程的施工相关的职业健康安全管理活动";
 certEndDate = "2019-11-03";
 certMark = "CNAS";
 certNum = "03416S20679R0M";
 certStatus = "撤销";
 changeCertDate = "2018-05-05";
 ec = "None";
 employeeNums = <null>;
 entName = "一重集团大连工程建设有限公司";
 firstGetCertDate = "2016-11-04";
 haveCoverMoreAddress = "None";
 infoPostDate = "2018-05-08";
 orgAddress = "增光路33号"
 orgApprove = "CNCA-R-2002-002";
 orgName = "方圆标志认证集团有限公司";
 orgStatus = "有效";
 phoneNums = "010-68422203";
 postCertDate = "2016-11-04";
 sphereOfBusiness = "产品认证,中涉及产品形成过程的不可运输产品,白炽灯泡或放电灯,弧光灯及其附件；照明设备及其附件；其他电气设备及其零件,电动机,发电机,发电成套设备和变压器,电子设备及零部件,纺织品,服装和皮革制品,废旧物资,化工类产品,机械设备及零部件,家具；其他未分类产品,加工食品,饮料和烟草,建材产品,金属材料及金属制品,矿和矿物；电力,可燃气和水,陆地交通设备,木材和木制品；纸浆,纸和纸制品，印刷品,农林,牧,渔；中药,配电和控制设备及其零件；绝缘电线和电缆；光缆,水路交通设备,蓄电池,原电池,原电池组和其他电池及其零件,仪器设备,服务认证,保养和修理服务,科学研究服务,研究和开发服务；专业,科学和技术服务；其他专业,科学和技术服务,卫生保健和社会福利,管理体系认证,环境管理体系认证,信息安全管理体系认证,信息技术服务管理体系认证,职业健康安全管理体系认证,质量管理体系认证,国推认证,良好农业规范,能源管理体系,乳制品生产企业良好生产规范,乳制品生产企业危害分析与关键控制点,体系,食品安全管理体系,饲料产品,危害分析与关键控制点,有机产品,中国森林认证,强制性产品认证";
 superviseTime = "0";
 type = "310001";
 urlId = "00001804c21f60df8aead68684dbb3d4";
 validDate = "2018-12-10";
 };
 msg = "success";
 }
 */

@interface DDManageDetailModel : JSONModel
@property (nonatomic,copy)NSString <Optional> *authAgainTimes;//再认证次数
@property (nonatomic,copy)NSString <Optional> *authCoverAddressName;//认证覆盖的场所名称及地址
@property (nonatomic,copy)NSString <Optional> *authProject;//证书名称
@property (nonatomic,copy)NSString <Optional> *authRange;//认证覆盖的业务范围
@property (nonatomic,copy)NSString <Optional> *certEndDate;//证书到期日期
@property (nonatomic,copy)NSString <Optional> *certMark;//认可标识
@property (nonatomic,copy)NSString <Optional> *certNum;//证书数量
@property (nonatomic,copy)NSString <Optional> *certStatus;//证书状态
@property (nonatomic,copy)NSString <Optional> *changeCertDate;//换证日期
@property (nonatomic,copy)NSString <Optional> *ec;//EC9000证书,建筑施工企业质量管理体系认证对应的QMS覆盖范围
@property (nonatomic,copy)NSString <Optional> *employeeNums;//覆盖人数
@property (nonatomic,copy)NSString <Optional> *entName;//获奖组织名称
@property (nonatomic,copy)NSString <Optional> *firstGetCertDate;//初次获证日期
@property (nonatomic,copy)NSString <Optional> *haveCoverMoreAddress;//是否覆盖多场所
@property (nonatomic,copy)NSString <Optional> *infoPostDate;//信息上报日期
@property (nonatomic,copy)NSString <Optional> *orgAddress;//机构地址
@property (nonatomic,copy)NSString <Optional> *orgApprove;//机构批准号
@property (nonatomic,copy)NSString <Optional> *orgName;//机构名称
@property (nonatomic,copy)NSString <Optional> *orgStatus;//机构状态
@property (nonatomic,copy)NSString <Optional> *phoneNums;//电话
@property (nonatomic,copy)NSString <Optional> *postCertDate;//颁证日期
@property (nonatomic,copy)NSString <Optional> *sphereOfBusiness;//业务范围
@property (nonatomic,copy)NSString <Optional> *superviseTime;//监督次数
@property (nonatomic,copy)NSString <Optional> *type;
@property (nonatomic,copy)NSString <Optional> *urlId;
@property (nonatomic,copy)NSString <Optional> *validDate;//有效期
@end

NS_ASSUME_NONNULL_END
