//
//  DDEditAllTypesModel.h
//  GongChengDD
//
//  Created by xzx on 2018/5/29.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol DDSubItemModel<NSObject>
@end

@interface DDSubItemModel : JSONModel
@property (nonatomic,copy)NSString <Optional> *categoryType;
@property (nonatomic,copy)NSString <Optional> *isCategory;
@property (nonatomic,copy)NSString <Optional> *menuId;
@property (nonatomic,copy)NSString <Optional> *menuType;
@property (nonatomic,copy)NSString <Optional> *name;
@property (nonatomic,copy)NSString <Optional> *remark;
@property (nonatomic,copy)NSString <Optional> *sortNum;
@property (nonatomic,copy)NSString <Optional> *toAction;
//@property (nonatomic,copy)NSString <Optional> *url;
//@property (nonatomic,copy)NSString <Optional> *url1;
//@property (nonatomic,copy)NSString <Optional> *urlThumb;
//@property (nonatomic,copy)NSString <Optional> *urlThumb1;
@property (nonatomic,copy)NSString <Optional> *iconFileId;
@end

@interface DDEditAllTypesModel : JSONModel

/*
 categoryType = "qyxx";
 isCategory = 0;
 menuId = 12;
 menuType = 1002;
 name = "企业信息"
 remark = <null>;
 sortNum = 1;
 subItem = [
 {
 categoryType = "qyxx";
 isCategory = 1;
 menuId = 6;
 menuType = 1002;
 name = "找企业"
 remark = "{"toAction":"searchEnterprice"}";
 sortNum = 1;
 toAction = "searchEnterprice";
 url = "http://192.168.0.221:8080/fs/flib/fs/img/20180518/03ce56a0f4164be7a060fdffe2b29f75.png";
 url1 = <null>;
 urlThumb = "http://192.168.0.221:8080/fs/flib/fs/img/20180518/03ce56a0f4164be7a060fdffe2b29f75_timg.png";
 urlThumb1 = <null>;
 },
 */

@property (nonatomic, copy) NSString <Optional> *categoryType;
@property (nonatomic, copy) NSString <Optional> *isCategory;
@property (nonatomic, copy) NSString <Optional> *menuId;
@property (nonatomic, copy) NSString <Optional> *menuType;
@property (nonatomic, copy) NSString <Optional> *name;
@property (nonatomic, copy) NSString <Optional> *remark;
@property (nonatomic, copy) NSString <Optional> *sortNum;
@property (nonatomic, copy) NSArray <Optional,DDSubItemModel> *subItem;

@end
