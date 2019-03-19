//
//  DDHotSearchModel.h
//  GongChengDD
//
//  Created by xzx on 2018/5/18.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface DDHotSearchModel : JSONModel

/*
 addtime = "2018-05-10 10:15:03";
 deleted = 0;
 enterpriseId = 1229292237947136;
 searchContent = "苹果（中国）有限公司"
 searchCount = 500;
 searchId = 6;
 searchTitle = "苹果X";
 searchType = 6;
 */

@property (nonatomic, copy) NSString <Optional> *addtime;
@property (nonatomic, copy) NSString <Optional> *deleted;
@property (nonatomic, copy) NSString <Optional> *enterpriseId;
@property (nonatomic, copy) NSString <Optional> *searchContent;
@property (nonatomic, copy) NSString <Optional> *searchCount;
@property (nonatomic, copy) NSString <Optional> *searchId;
@property (nonatomic, copy) NSString <Optional> *searchTitle;
@property (nonatomic, copy) NSString <Optional> *searchType;


@end
