//
//  DDSearchBusinessInfoListVC.h
//  GongChengDD
//
//  Created by xzx on 2018/9/19.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDSearchBusinessInfoListVC : UIViewController

    @property (nonatomic,strong) NSString *menuId;//搜索的类型
    @property (nonatomic,strong) NSString *searchText;//上个页面传下来的输入的搜索文本
    
@end

NS_ASSUME_NONNULL_END
