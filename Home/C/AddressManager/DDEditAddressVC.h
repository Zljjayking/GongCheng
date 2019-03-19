//
//  DDEditAddressVC.h
//  GongChengDD
//
//  Created by xzx on 2018/7/3.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDEditAddressVC : UIViewController

@property (nonatomic,strong) NSString *historyAddressId;//地址ID
@property (nonatomic,strong) NSString *isDefault;//是否是默认地址
@property (nonatomic,copy) void(^addBlock)(void);

@end
