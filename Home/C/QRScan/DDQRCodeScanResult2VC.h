//
//  DDQRCodeScanResult2VC.h
//  GongChengDD
//
//  Created by xzx on 2018/8/24.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import<WebKit/WebKit.h>

@interface DDQRCodeScanResult2VC : UIViewController

@property(nonatomic,copy) void(^backBlock)(void);
@property(nonatomic,copy) NSString *hostUrl;

@end
