//
//  DDLiveManagerNewAddApplyVC.h
//  GongChengDD
//
//  Created by xzx on 2018/7/23.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDLiveManagerNewAddApplyVC : UIViewController

@property (nonatomic,strong) NSString *agencyName;//培训机构名称
@property (nonatomic,strong) NSString *agencyId;//培训机构ID
/*
 1二建继续教育 2安全员新培 3安全员继续教育 4现场施工新培 5现场施工继续教育 10一级建造师新培 11二级建造师新培 12一级消防工程师新培 13二级消防工程师新培 14一级造价工程师新培 15二级造价工程师新培 16监理工程师新培 17安全工程师新培
 */
@property (nonatomic,strong) NSString *examinType;

@end
