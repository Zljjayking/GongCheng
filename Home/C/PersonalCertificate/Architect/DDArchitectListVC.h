//
//  DDArchitectListVC.h
//  GongChengDD
//
//  Created by xzx on 2018/9/25.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDArchitectListVC : UIViewController

@property (nonatomic,strong) NSString *enterpriseId;
@property (nonatomic,strong) NSString *toAction;
@property (nonatomic,strong) NSString *type;//1一级结构师 2二级结构师 3化工工程师列表 4一级建筑师 5二级建筑师

@end

NS_ASSUME_NONNULL_END
