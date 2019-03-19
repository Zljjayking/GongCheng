//
//  DDSevereIllegalAndAbnormalVC.h
//  GongChengDD
//
//  Created by xzx on 2018/10/22.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDSevereIllegalAndAbnormalVC : UIViewController

@property (nonatomic,strong) NSString *enterpriseId;
@property (nonatomic,strong) NSString *toAction;
@property (nonatomic,strong) NSString *illegalType;//1表示严重违法，2表示经营异常

@end

NS_ASSUME_NONNULL_END
