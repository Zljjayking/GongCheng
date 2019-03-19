//
//  DDBuyAAACertificateVC.h
//  GongChengDD
//
//  Created by csq on 2019/2/25.
//  Copyright © 2019 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDMyMenusListModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^refreshOrderListBlock)(void);
typedef void(^refreshChooseBlock)(void);

@interface DDBuyAAACertificateVC : UIViewController
@property (nonatomic, assign) NSInteger type;//1.从企业详情进  2.从我的信用报告列表进 3.从服务进
@property (nonatomic,strong) NSString *enterpriseId;//公司Id
@property (nonatomic,strong) NSString *enterpriseName;//公司名称
@property (nonatomic,strong) NSString *email;//公司邮箱
@property (nonatomic, strong) NSString *price;//价格
@property (nonatomic, strong) NSString *invitedCount;//分享人数
@property (nonatomic, strong) DDMyMenusListModel *orderModel;
@property (nonatomic, strong) NSString *orderID;
@property (nonatomic, copy) refreshOrderListBlock refreshBlock;
@property (nonatomic, copy) refreshChooseBlock refreshChoose;
@end

NS_ASSUME_NONNULL_END
