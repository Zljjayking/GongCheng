//
//  DDSearchAAACertiListModel.h
//  GongChengDD
//
//  Created by xzx on 2018/9/21.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDSearchAAACertiListModel : JSONModel

/*
 enterpriseId = "1";
 enterpriseName = "<font color='red'>测试</font>";
 id = "1";
 level = "AAA";
 publishDate = "2018-09-19"
 */

@property (nonatomic, copy) NSString <Optional> *enterpriseId;
@property (nonatomic, copy) NSString <Optional> *enterpriseName;
@property (nonatomic, copy) NSString <Optional> *id;
@property (nonatomic, copy) NSString <Optional> *level;
@property (nonatomic, copy) NSString <Optional> *publishDate;

@property (nonatomic, copy) NSAttributedString <Optional> *enterpriseNameAttrStr;

@end

NS_ASSUME_NONNULL_END
