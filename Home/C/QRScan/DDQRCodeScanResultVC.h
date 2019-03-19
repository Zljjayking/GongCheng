//
//  DDQRCodeScanResultVC.h
//  GongChengDD
//
//  Created by xzx on 2018/7/31.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDQRCodeScanResultVC : UIViewController

@property(nonatomic,strong) NSString *stringValue;
@property (nonatomic,copy) void(^cancelBlock)(void);
@property (nonatomic,copy) void(^scanSuccessBlock)(void);

@end
