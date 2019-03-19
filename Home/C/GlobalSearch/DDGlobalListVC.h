//
//  DDGlobalListVC.h
//  GongChengDD
//
//  Created by xzx on 2018/5/17.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum:NSInteger {
    DDGlobalListTypeDefault=0,
    DDGlobalListTypeHistory=1,
}DDGlobalListType;

@interface DDGlobalListVC : UIViewController

@property (nonatomic,strong) NSString *searchText;//上个页面传下来的输入的搜索文本
@property (nonatomic,assign) NSInteger index;
@property (nonatomic,copy) void(^indexBlock)(NSInteger index);//将当前的segment定位反传给上一页
@property (nonatomic,assign) DDGlobalListType globalListType;
@property (nonatomic,copy) void(^searchStringBlock)(NSString *searchStr);//反传给上一页搜索框里的内容
@end
