//
//  DDBuyCreditReportVC.h
//  GongChengDD
//
//  Created by csq on 2019/2/22.
//  Copyright © 2019 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDMyMenusListModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^refreshOrderList)(void);
@interface DDBuyCreditReportVC : UIViewController

@property (nonatomic, assign) NSInteger type;//1.从企业详情进  2.从我的订单进
@property (nonatomic,strong) NSString *enterpriseId;//公司Id
@property (nonatomic,strong) NSString *enterpriseName;//公司名称
@property (nonatomic,strong) NSString *email;//公司邮箱
@property (nonatomic, strong) NSString *price;//价格
@property (nonatomic, strong) DDMyMenusListModel *orderModel;
@property (nonatomic, strong) NSString *orderID;
@property (nonatomic, copy) refreshOrderList refreshBlock;
@end

NS_ASSUME_NONNULL_END
