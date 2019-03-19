//
//  DDSearchAccidentSituationListModel.h
//  GongChengDD
//
//  Created by xzx on 2018/6/4.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface DDSearchAccidentSituationListModel : JSONModel

/*
 accident_id = 3;
 accident_issue_time = "2018-03-17"
 accident_title = "“热心大爷”栽了";
 enterprise_id = 1229292237947136;
 enterprise_name = "<font color='red'>江苏</font>康森迪信息科技有限公司";
 staff_name = "石原里美";
 */

@property (nonatomic, copy) NSString <Optional> *accident_id;
@property (nonatomic, copy) NSString <Optional> *accident_issue_time;
@property (nonatomic, copy) NSString <Optional> *accident_title;
@property (nonatomic, copy) NSString <Optional> *enterprise_id;
@property (nonatomic, copy) NSString <Optional> *enterprise_name;
@property (nonatomic, copy) NSString <Optional> *staff_name;
@property (nonatomic, copy) NSString <Optional> *staff_info_id;

@property (nonatomic, copy) NSAttributedString <Optional> *titleStr;
@property (nonatomic, copy) NSAttributedString <Optional> *enterpriseStr;

@end
