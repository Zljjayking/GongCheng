//
//  DDFindingEnterpriseVC.h
//  GongChengDD
//
//  Created by xzx on 2018/11/2.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDFindingEnterpriseVC : UIViewController
@property (weak,nonatomic)UIViewController * mainViewContoller;
@property (nonatomic,strong) UITableView *tableView;
-(void)viewWillDidCurrentView;
-(void)viewWillCloseView;
@end

NS_ASSUME_NONNULL_END
