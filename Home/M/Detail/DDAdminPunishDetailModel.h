//
//  DDAdminPunishDetailModel.h
//  GongChengDD
//
//  Created by xzx on 2018/6/6.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface DDAdminPunishDetailModel : JSONModel

/*
 bulletin_department = "上海市城乡建设和管理委员会";
 end_time = <null>;
 enterprise_name = "中科建设开发总公司";
 punish_gist = <null>;
 punish_name = "关于中科建设开发总公司在周浦镇15号地块建设工程(3标）从事(或存在)不再具备安全生产条件的行为通报";
 punish_original_href = "http://www.shjjw.gov.cn/gb/node2/n4/n357/userobject12ai29.html"
 punish_result = <null>;
 punish_time = "2016-01-31";
 punish_type = <null>;
 staff_name = "董生友";
 start_time = <null>;
 */

@property (nonatomic,copy) NSString <Optional> *bulletin_department;
@property (nonatomic,copy) NSString <Optional> *end_time;
@property (nonatomic,copy) NSString <Optional> *enterprise_name;
@property (nonatomic,copy) NSString <Optional> *punish_gist;
@property (nonatomic,copy) NSString <Optional> *punish_name;
@property (nonatomic,copy) NSString <Optional> *punish_original_href;
@property (nonatomic,copy) NSString <Optional> *punish_original_img;
@property (nonatomic,copy) NSString <Optional> *punish_result;
@property (nonatomic,copy) NSString <Optional> *punish_time;
@property (nonatomic,copy) NSString <Optional> *punish_type;
@property (nonatomic,copy) NSString <Optional> *staff_name;
@property (nonatomic,copy) NSString <Optional> *start_time;
@property (nonatomic,copy) NSString <Optional> *book_num;
@property (nonatomic,copy) NSString <Optional> *punish_explain;
@property (nonatomic,copy) NSString <Optional> *enclosure;//附件名
@property (nonatomic,copy) NSString <Optional> *enclosureUrl;//附件地址

@end
