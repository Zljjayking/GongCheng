//
//  DDAllSearchVC.h
//  GongChengDD
//
//  Created by xzx on 2018/5/10.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDAllSearchVC : UIViewController

@property (nonatomic,strong) NSString *type;//1表示从全局搜索过来的
@property (nonatomic,strong) NSString *menuId;//搜索的类型
@property (nonatomic,strong) NSString *placeholderText;//搜索框默认文本
@property (nonatomic,strong) NSString *audioSingleText;//特例：从语音搜索跳过来的
@property (nonatomic,strong) NSString *audioType;//1表示从语音搜索跳过来的

@end
