//
//  DDCheckAppVerModel.h
//  GongChengDD
//
//  Created by csq on 2018/8/8.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "JSONModel.h"

/**
 {
 code = 0
 data = {
   must = 0;
   summary = "1.【优化】企业曾用名、经营状态；2.【优化】修复行业动态定位显示；3.【优化】提升性能及用户体验";
   url = "https://itunes.apple.com/cn/app/id1344634679?mt=8";
   verName = "2.0.1"
   verVal = 100000500;
 };
 msg = "success";
 }
 */
@interface DDCheckAppVerModel : JSONModel
@property (nonatomic,copy)NSString <Optional> *must;//是否强制更新 1强制 0非强制
@property (nonatomic,copy)NSString <Optional> *verName;//新版本号
@property (nonatomic,copy)NSString <Optional> *url;//iOS更新链接
@property (nonatomic,copy)NSString <Optional> *verVal;
@property (nonatomic,copy)NSString <Optional> *areaVer;//文件版本号
@property (nonatomic,copy)NSString <Optional> *areaUrl;//文件下载地址
@property (nonatomic,copy)NSString <Optional> *summary;//提示语

@end
