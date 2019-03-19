//
//  DDExaminationNotice1DetailModel.h
//  GongChengDD
//
//  Created by xzx on 2018/6/7.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface DDExaminationNotice1DetailModel : JSONModel

/*
 categoryType = "kstz";
 icoClass = <null>;
 isCategory = 1;
 menuId = 81;
 menuType = 1006;
 name = "一级建造师";
 remark = <null>;
 sortNum = 1;
 tab = "110000";
 url = <null>;
 urlThumb = <null>;
 urllink = <null>
 */

@property (nonatomic,copy)NSString <Optional> *categoryType;
@property (nonatomic,copy)NSString <Optional> *icoClass;
@property (nonatomic,copy)NSString <Optional> *isCategory;
@property (nonatomic,copy)NSString <Optional> *menuId;
@property (nonatomic,copy)NSString <Optional> *menuType;
@property (nonatomic,copy)NSString <Optional> *name;
@property (nonatomic,copy)NSString <Optional> *remark;
@property (nonatomic,copy)NSString <Optional> *sortNum;
@property (nonatomic,copy)NSString <Optional> *tab;
@property (nonatomic,copy)NSString <Optional> *url;
@property (nonatomic,copy)NSString <Optional> *urlThumb;
@property (nonatomic,copy)NSString <Optional> *urllink;

@end
