//
//  DDBuilderAddTelInputVC.h
//  GongChengDD
//
//  Created by xzx on 2018/7/18.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDBuilderAddTelInputVC : UIViewController

@property (nonatomic,copy) void(^userIdBlock)(NSString *userId,NSString *tel);

@end
