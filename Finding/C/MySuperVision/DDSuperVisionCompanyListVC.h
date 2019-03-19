//
//  DDSuperVisionCompanyListVC.h
//  GongChengDD
//
//  Created by xzx on 2018/11/26.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SuperVisionCompanyDelete <NSObject>

-(void)SuperVisionCompanyDeleteSucceed;

@end

NS_ASSUME_NONNULL_BEGIN

@interface DDSuperVisionCompanyListVC : UIViewController
@property(nonatomic,weak)id<SuperVisionCompanyDelete>delegate;
@end

NS_ASSUME_NONNULL_END
