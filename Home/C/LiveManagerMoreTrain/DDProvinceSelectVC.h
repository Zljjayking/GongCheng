//
//  DDProvinceSelectVC.h
//  GongChengDD
//
//  Created by Koncendy on 2017/12/1.
//  Copyright © 2017年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDProvinceSelectVC : UIViewController

@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) void (^provinceSelectBlock)(NSString *issuedDeptId,NSString *issuedDeptSource);

@end
