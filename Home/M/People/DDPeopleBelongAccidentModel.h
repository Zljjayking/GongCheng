//
//  DDPeopleBelongAccidentModel.h
//  GongChengDD
//
//  Created by xzx on 2018/5/28.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface DDPeopleBelongAccidentModel : JSONModel

/*
 accident_id = 2;
 accident_issue_time = "2018-03-29"
 accident_title = "10号万金油+3线齐发，没伊布就当平民海盗!爽翻世界";
 staff_name = "石原里美";
 */

@property (nonatomic,copy) NSString <Optional> *accident_id;
@property (nonatomic,copy) NSString <Optional> *accident_issue_time;
@property (nonatomic,copy) NSString <Optional> *accident_title;
@property (nonatomic,copy) NSString <Optional> *staff_name;

@end
