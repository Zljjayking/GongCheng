//
//  DDChooseBuyAAACertificateVC.h
//  GongChengDD
//
//  Created by csq on 2019/2/25.
//  Copyright © 2019 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDChooseBuyAAACertificateVC : UIViewController
@property (nonatomic,strong) NSString *enterpriseId;//公司Id
@property (nonatomic,strong) NSString *enterpriseName;//公司名称
@property (nonatomic,strong) NSString *email;//公司邮箱
@property (nonatomic, strong) NSString *price;//价格
@property (nonatomic, assign) NSInteger type;//1.从企业详情进入  2.从信用报告列表进入 3.从服务页面进入
@end

NS_ASSUME_NONNULL_END
