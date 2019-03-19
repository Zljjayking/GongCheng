//
//  DDSerarchExcutedPeopleListModel.h
//  GongChengDD
//
//  Created by xzx on 2018/6/4.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface DDSerarchExcutedPeopleListModel : JSONModel

/*
 execute_case_number = "（2017）民抗字第48号";
 execute_court = "最高人民检察院";
 execute_create_date = "2018-05-29";
 execute_id = 2;
 execute_person = "<font color='red'>江苏</font>康森迪信息科技有限公司"
 execute_standard = "345913";
 */

@property (nonatomic, copy) NSString <Optional> *execute_case_number;
@property (nonatomic, copy) NSString <Optional> *execute_court;
@property (nonatomic, copy) NSString <Optional> *execute_create_date;
@property (nonatomic, copy) NSString <Optional> *execute_publish_date;
@property (nonatomic, copy) NSString <Optional> *execute_id;
@property (nonatomic, copy) NSString <Optional> *execute_person;
@property (nonatomic, copy) NSString <Optional> *execute_standard;

@property (nonatomic, copy) NSAttributedString <Optional> *nameAttriStr;

@end
