//
//  DDProjectSubscribeVC.h
//  GongChengDD
//
//  Created by xzx on 2018/11/26.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDProjectSubscribeVC : UIViewController

@property (nonatomic,strong) NSString *isCallBidding;//1表示是从招标监控过来的
@property (nonatomic,strong) NSString *type;//1表示要传数据过来了
@property (nonatomic,strong) NSArray *passRegionStrs;
@property (nonatomic,strong) NSArray *passRegionIds;
@property (nonatomic,strong) NSArray *passProjectTypes;

@end

NS_ASSUME_NONNULL_END
