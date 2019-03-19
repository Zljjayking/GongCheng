//
//  DDCultureWorkSiteVC.h
//  GongChengDD
//
//  Created by csq on 2018/9/21.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 文明工地,绿色工地
 */
@interface DDCultureWorkSiteVC : UIViewController
//企业id
@property (nonatomic,copy)NSString * enterpriseId;

//1文明工地 2绿色工地
@property (nonatomic,copy)NSString * type;
@end

NS_ASSUME_NONNULL_END
