//
//  DDValidTimeSummaryVC.h
//  GongChengDD
//
//  Created by csq on 2017/12/4.
//  Copyright © 2017年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDValidTimeSummaryVC : UIViewController
@property (nonatomic,assign) NSInteger index;
@property (nonatomic,copy) NSString * type;//1表示从证书页面跳转过来，左上角显示我的，其余情况都显示返回
// 企业id
@property (nonatomic,copy)NSString * enterpriseId;
@property (nonatomic,strong) NSString *isOpen;//0隐藏 非0显示
@end
