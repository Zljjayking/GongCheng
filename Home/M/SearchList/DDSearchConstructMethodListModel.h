//
//  DDSearchConstructMethodListModel.h
//  GongChengDD
//
//  Created by xzx on 2018/9/20.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDSearchConstructMethodListModel : JSONModel

/*
 enterpriseId = "1";
 tcmAwardYear = "2016~2017年"
 tcmNumber = "<font color='red'>GJWDFF02</font><font color='red'>-</font><font color='red'>2017</font>";
 tcmTitle = "大理石装修施工工法";
 tcm_id = "2";
 unitName = "一重集团大连工程建设有限公司";
 */

@property (nonatomic, copy) NSString <Optional> *enterpriseId;
@property (nonatomic, copy) NSString <Optional> *tcmAwardYear;
@property (nonatomic, copy) NSString <Optional> *tcmNumber;
@property (nonatomic, copy) NSString <Optional> *tcmTitle;
@property (nonatomic, copy) NSString <Optional> *tcm_id;
@property (nonatomic, copy) NSString <Optional> *unitName;

@property (nonatomic, copy) NSAttributedString <Optional> *titleAttrStr;
@property (nonatomic, copy) NSAttributedString <Optional> *numberAttrStr;
@property (nonatomic, copy) NSAttributedString <Optional> *enterpriseNameAttrStr;

@end

NS_ASSUME_NONNULL_END
