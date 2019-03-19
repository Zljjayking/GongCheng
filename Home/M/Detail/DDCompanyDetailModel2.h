//
//  DDCompanyDetailModel2.h
//  GongChengDD
//
//  Created by xzx on 2018/5/24.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol DDSubModel<NSObject>
@end

@interface DDSubModel : JSONModel
@property (nonatomic,copy) NSString <Optional> *icoClass;
@property (nonatomic,copy) NSString <Optional> *menuId;
@property (nonatomic,copy) NSString <Optional> *name;
@property (nonatomic,copy) NSString <Optional> *toAction;
@property (nonatomic,copy) NSString <Optional> *totalNum;
@end


@interface DDCompanyDetailModel2 : JSONModel

@property (nonatomic,copy) NSString <Optional> *categoryType;
@property (nonatomic,copy) NSString <Optional> *isCategory;
@property (nonatomic,copy) NSString <Optional> *menuId;
@property (nonatomic,copy) NSString <Optional> *menuType;
@property (nonatomic,copy) NSString <Optional> *name;
@property (nonatomic,copy) NSString <Optional> *url;
@property (nonatomic,copy) NSArray <Optional,DDSubModel> *sub;

@end
