//
//  DDAccidentSituationDetailModel.h
//  GongChengDD
//
//  Created by xzx on 2018/6/6.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface DDAccidentSituationDetailModel : JSONModel

/*
 accident_issue_time = "2018-07-14"
 accident_original_href = "www.baidu.com";
 accident_title = "锤子革命新品惊现苹果系统！官方：视频制作错误";
 staff_name = "星川高岭";
 */

@property (nonatomic,copy) NSString <Optional> *accident_issue_time;
@property (nonatomic,copy) NSString <Optional> *accident_original_href;
@property (nonatomic,copy) NSString <Optional> *accident_original_img;
@property (nonatomic,copy) NSString <Optional> *accident_title;
@property (nonatomic,copy) NSString <Optional> *staff_name;
@property (nonatomic,copy) NSString <Optional> *content;
@property (nonatomic,copy) NSString <Optional> *enterprise_name;
@property (nonatomic,copy) NSString <Optional> *enclosure;
@property (nonatomic,copy) NSString <Optional> *enclosureUrl;

@end
