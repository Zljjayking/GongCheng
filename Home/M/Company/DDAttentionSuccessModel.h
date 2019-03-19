//
//  DDAttentionSuccessModel.h
//  GongChengDD
//
//  Created by csq on 2018/6/8.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <JSONModel/JSONModel.h>

/*
 attentionType = 0;
 createdTime = "2018-06-08 23:44:55";
 createdUserId = 1483497843458345;
 entId = 1382376615317760;
 updatedTime = "2018-06-08 23:44:55"
 updatedUserId = 1483497843458345;
 userId = 1483497843458345;
 */
@interface DDAttentionSuccessModel : JSONModel
@property (nonatomic, copy) NSString <Optional> *attentionType;

@end
