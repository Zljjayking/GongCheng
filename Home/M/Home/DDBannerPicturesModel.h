//
//  DDBannerPicturesModel.h
//  GongChengDD
//
//  Created by xzx on 2018/6/14.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface DDBannerPicturesModel : JSONModel

/*
 createdTime = "2018-08-07 17:49:15";
 createdUserId = <null>;
 deleted = 0;
 enabled = 1;
 id = 1;
 imgFileId = 1795770009748480;
 moduleType = "1";
 remark = "吾问无为谓";
 sortNum = "1";
 toActive = "1";
 updatedTime = "2018-08-07 17:49:15";
 updatedUserId = <null>
 url = "9";
 */

@property (nonatomic, copy) NSString <Optional> *createdTime;
@property (nonatomic, copy) NSString <Optional> *createdUserId;
@property (nonatomic, copy) NSString <Optional> *deleted;
@property (nonatomic, copy) NSString <Optional> *enabled;
@property (nonatomic, copy) NSString <Optional> *id;
@property (nonatomic, copy) NSString <Optional> *imgFileId;
@property (nonatomic, copy) NSString <Optional> *moduleType;
@property (nonatomic, copy) NSString <Optional> *remark;
@property (nonatomic, copy) NSString <Optional> *sortNum;
@property (nonatomic, copy) NSString <Optional> *toActive;
@property (nonatomic, copy) NSString <Optional> *updatedTime;
@property (nonatomic, copy) NSString <Optional> *updatedUserId;
@property (nonatomic, copy) NSString <Optional> *url;

@end
