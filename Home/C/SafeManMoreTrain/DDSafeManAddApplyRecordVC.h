//
//  DDSafeManAddApplyRecordVC.h
//  GongChengDD
//
//  Created by xzx on 2018/7/20.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDSafeManAddApplyRecordVC : UIViewController

@property (nonatomic,strong) NSString *certType;// 2 安全员新培 3安全员继续教育（手动添加）
@property (nonatomic,strong) NSString *agencyName;//培训机构名称
@property (nonatomic,strong) NSString *agencyId;//培训机构ID

@end
