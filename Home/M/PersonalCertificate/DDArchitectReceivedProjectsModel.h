//
//  DDArchitectReceivedProjectsModel.h
//  GongChengDD
//
//  Created by xzx on 2018/9/29.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDArchitectReceivedProjectsModel : JSONModel

/*
 achCode = "4112811707310101";
 address = "河南省-三门峡市-义马市";
 enterprise_name = "义马市绿城北华物流服务有限责任公司";
 id = 3376;
 name = "王勇"
 title = "义马市绿城北华物流服务建设项目4#楼";
 type = "房屋建筑工程";
 */

@property (nonatomic,copy)NSString <Optional> *achCode;
@property (nonatomic,copy)NSString <Optional> *address;
@property (nonatomic,copy)NSString <Optional> *enterprise_name;
@property (nonatomic,copy)NSString <Optional> *id;
@property (nonatomic,copy)NSString <Optional> *name;
@property (nonatomic,copy)NSString <Optional> *title;
@property (nonatomic,copy)NSString <Optional> *type;

@end

NS_ASSUME_NONNULL_END
