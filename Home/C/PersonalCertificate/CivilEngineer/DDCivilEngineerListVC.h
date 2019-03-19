//
//  DDCivilEngineerListVC.h
//  GongChengDD
//
//  Created by xzx on 2018/9/25.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDCivilEngineerListVC : UIViewController

@property (nonatomic,strong) NSString *enterpriseId;
@property (nonatomic,strong) NSString *toAction;
@property (nonatomic,strong) NSString *type;//1土木工程师 2公用设备师 3电气工程师 4监理工程师 5造价工程师

@end

NS_ASSUME_NONNULL_END
