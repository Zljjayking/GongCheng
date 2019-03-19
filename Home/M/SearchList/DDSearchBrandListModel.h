//
//  DDSearchBrandListModel.h
//  GongChengDD
//
//  Created by xzx on 2018/9/25.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDSearchBrandListModel : JSONModel

/*
 applicationDate = "2009-09-04"
 brandImg = "http://tm-image.qichacha.com/89caa8e28b1fa0ebbe4b2475e1b7430b.jpg";
 brandName = "九状元";
 brandStatus = "商标转让中";
 brandType = "33-酒";
 enterpriseId = "80599";
 enterpriseName = "业兴<font color='red'>实业</font><font color='red'>集团</font>有限公司";
 id = "001a547692729df1e17f6c6fb7d4217a";
 registerId = "7673142";
 */

@property (nonatomic, copy) NSString <Optional> *applicationDate;
@property (nonatomic, copy) NSString <Optional> *brandImg;
@property (nonatomic, copy) NSString <Optional> *brandName;
@property (nonatomic, copy) NSString <Optional> *brandStatus;
@property (nonatomic, copy) NSString <Optional> *brandType;
@property (nonatomic, copy) NSString <Optional> *enterpriseId;
@property (nonatomic, copy) NSString <Optional> *enterpriseName;
@property (nonatomic, copy) NSString <Optional> *id;
@property (nonatomic, copy) NSString <Optional> *registerId;

@property (nonatomic, copy) NSAttributedString <Optional> *titleAttrStr;
@property (nonatomic, copy) NSAttributedString <Optional> *registerIdAttrStr;
@property (nonatomic, copy) NSAttributedString <Optional> *enterpriseNameAttrStr;

@end

NS_ASSUME_NONNULL_END
