//
//  DDTrainInputPersonalInfoVC.h
//  GongChengDD
//
//  Created by xzx on 2018/7/9.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDTrainInputPersonalInfoVC : UIViewController

@property (nonatomic,strong) NSString *type;//类型:1,填写姓名；2,填写身份证号；3,证书编号
@property (nonatomic,strong) NSString *contentStr;
@property (nonatomic,copy) void(^inputInfoBlock)(NSString *inputInfo);

@end
