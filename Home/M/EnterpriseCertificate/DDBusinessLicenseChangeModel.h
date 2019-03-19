//
//  DDBusinessLicenseChangeModel.h
//  GongChengDD
//
//  Created by csq on 2018/8/6.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "JSONModel.h"
/*
 afterHtmlValue = "";
 afterValue = "";
 beforeHtmlValue = "";
 beforeValue = "";
 certificateNo = <null>;
 changeInfoId = 5370529;
 changeItem = "经营范围"
 changeTime = "2015-03-10 00:00:00";
 createdTime = "2018-07-21 15:50:49";
 createdUserId = 0;
 deleted = 0;
 enterpriseId = 82460;
 updatedTime = "2018-07-21 15:50:49";
 updatedUserId = 0;
 }

 */
@interface DDBusinessLicenseChangeModel : JSONModel
@property (nonatomic,copy) NSString<Optional> *afterHtmlValue;
@property (nonatomic,copy) NSString<Optional> *afterValue;
@property (nonatomic,copy) NSString<Optional> *beforeHtmlValue;
@property (nonatomic,copy) NSString<Optional> *beforeValue;
@property (nonatomic,copy) NSString<Optional> *certificateNo;
@property (nonatomic,copy) NSString<Optional> *changeInfoId;
@property (nonatomic,copy) NSString<Optional> *changeItem;
@property (nonatomic,copy) NSString<Optional> *changeTime;
@property (nonatomic,copy) NSString<Optional> *createdTime;
@property (nonatomic,copy) NSString<Optional> *createdUserId;
@property (nonatomic,copy) NSString<Optional> *deleted;
@property (nonatomic,copy) NSString<Optional> *enterpriseId;
@property (nonatomic,copy) NSString<Optional> *updatedTime;
@property (nonatomic,copy) NSString<Optional> *updatedUserId;

//以下是自定义字段
@property (nonatomic,copy) NSNumber<Optional> *showAllContent;//是否完全显示"变更记录"
@property (nonatomic,copy) NSNumber<Optional> *showMoreButton;//是否显示"更多"按钮
@property (nonatomic,assign)NSNumber<Optional> *longHTMLHeight;//缓存长度较长的HTML的高度
//@property (nonatomic,assign)NSNumber<Optional> *fixedHTMLHeight;//固定长度
//处理数据
- (void)handelData;
@end
