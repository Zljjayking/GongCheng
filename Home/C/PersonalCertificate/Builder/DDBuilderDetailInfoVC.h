//
//  DDBuilderDetailInfoVC.h
//  GongChengDD
//
//  Created by xzx on 2018/12/1.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDBuilderDetailInfoVC : UIViewController

@property (nonatomic,strong) NSString *staffInfoId;
@property (nonatomic,strong) NSString *type;//0一级建造师 1二级建造师
@property (nonatomic,strong) NSString *specialityCode;//专业code
@property (nonatomic, strong)NSString *titleStr;//分享标题
@property (nonatomic, strong)NSString *nameStr;//分享名字
- (void)changeSelectIndex;
@end

NS_ASSUME_NONNULL_END
