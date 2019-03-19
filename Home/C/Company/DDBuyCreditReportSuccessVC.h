//
//  DDBuyCreditReportSuccessVC.h
//  GongChengDD
//
//  Created by csq on 2019/2/22.
//  Copyright © 2019 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDMyMenusListModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^refreshOrderListBlock)(void);
typedef void(^refreshOrderDetailBlock)(DDMyMenusListModel *model);
typedef void(^deleteOrderModelBlock)(void);
@interface DDBuyCreditReportSuccessVC : UIViewController
@property (nonatomic, assign) NSInteger type;//2、aaa证书 默认1是信用报告 3.信用报告页面购买AAA 4.订单列表购买信用报告 5.从订单列表继续购买信用报告 6.从订单详情继续购买AAA证书 7.订单列表继续购买AAA证书 8.服务界面购买AAA证书
@property (nonatomic, strong) NSString *orderID;//aaa证书购买的orderID
@property (nonatomic, strong) DDMyMenusListModel *model;
@property (nonatomic, copy) refreshOrderListBlock refreshBlock;
@property (nonatomic, copy) refreshOrderDetailBlock refreshDetailBlock;
@property (nonatomic, copy) deleteOrderModelBlock deleteBlock;
@end

NS_ASSUME_NONNULL_END
