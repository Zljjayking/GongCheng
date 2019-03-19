//
//  DDProjectDetailVC.h
//  GongChengDD
//
//  Created by xzx on 2018/5/23.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 项目详情页
 */
@interface DDProjectDetailVC : UIViewController

/**
 中标id
 */
@property (nonatomic,strong) NSString *winCaseId;
@property(nonatomic,assign) BOOL isHiddenBottom;
@end
