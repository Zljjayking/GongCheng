//
//  DDShareAndBuyCertificateVC.h
//  GongChengDD
//
//  Created by csq on 2019/2/25.
//  Copyright © 2019 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^refreshChooseBlockTwo)(void);
@interface DDShareAndBuyCertificateVC : UIViewController
@property (nonatomic,strong) NSString *email;//公司邮箱
@property (nonatomic, strong) NSString *price;//优惠的价格
@property (nonatomic,strong) NSString *enterpriseId;//公司Id
@property (nonatomic,strong) NSString *enterpriseName;//公司名称
@property (nonatomic, strong) NSString *inviteCode;//邀请码
@property (nonatomic, strong) NSString *inviteCount;//需邀请人数
@property (nonatomic, strong) NSString *invitedCount;//已邀请人数
@property (nonatomic, assign) BOOL isCanBuy;
@property (nonatomic, assign) BOOL isClaimed;
@property (nonatomic, copy) refreshChooseBlockTwo refreshChooseTwo;
@property (nonatomic, assign) NSInteger type;//1.从企业详情进  2.信用报告列表进
@end

NS_ASSUME_NONNULL_END
