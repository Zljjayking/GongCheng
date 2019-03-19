//
//  DDTalentSubscribeVC.h
//  GongChengDD
//
//  Created by xzx on 2018/11/24.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDTalentSubscribeVC : UIViewController

@property (nonatomic,strong) NSString *type;//1表示要传数据过来了
@property (nonatomic,strong) NSArray *passRegionIds;
@property (nonatomic,strong) NSArray *passCertiTypes;
@property (nonatomic,strong) NSString *passDate;

@end

NS_ASSUME_NONNULL_END
