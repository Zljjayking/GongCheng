//
//  DDFindingProjectVC.h
//  GongChengDD
//
//  Created by xzx on 2018/11/2.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDFindingProjectVC : UIViewController
@property (weak,nonatomic)UIViewController * mainViewContoller;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *projectClassArray;
@property (nonatomic, strong) NSMutableArray *moneyArray;
-(void)viewWillDidCurrentView;
-(void)viewWillCloseView;
@end

NS_ASSUME_NONNULL_END
