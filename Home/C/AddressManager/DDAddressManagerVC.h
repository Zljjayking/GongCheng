//
//  DDAddressManagerVC.h
//  GongChengDD
//
//  Created by xzx on 2018/7/3.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDAddressManagerModel.h"//model

typedef enum:NSInteger {
    DDAddressTypeDefault=0,
    DDAddressTypeSet=1, //设置
}DDAddressType;


@interface DDAddressManagerVC : UIViewController

@property (nonatomic,copy) void(^addressSelectBlock)(DDAddressManagerModel *model);
@property (nonatomic,assign) DDAddressType addressType;
@end
