//
//  DDSuperVisionSettingVC.m
//  GongChengDD
//
//  Created by xzx on 2018/11/22.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDSuperVisionSettingVC.h"

@interface DDSuperVisionSettingVC ()

@end

@implementation DDSuperVisionSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=kColorBackGroundColor;
    self.title=@"监控设置";
    self.navigationItem.leftBarButtonItem=[DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"返回" target:self action:@selector(leftButtonClick)];
    
//    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
//    if ([[UIApplication sharedApplication] canOpenURL:url]) {
//        [[UIApplication sharedApplication] openURL:url];
//    }
}

#pragma mark 返回上一级
- (void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}




@end
