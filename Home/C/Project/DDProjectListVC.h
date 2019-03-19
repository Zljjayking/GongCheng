//
//  DDProjectListVC.h
//  GongChengDD
//
//  Created by xzx on 2018/5/17.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDProjectListVC : UIViewController

@property (weak,nonatomic)UIViewController * mainViewContoller;
@property (nonatomic,strong) NSString *searchText;//上个页面传下来的输入的搜索文本
- (void)requestData;

@end
