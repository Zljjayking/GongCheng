//
//  DDManageTypeSelectView.h
//  GongChengDD
//
//  Created by csq on 2018/9/19.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class DDManageTypeSelectView;
@protocol DDManageTypeSelectViewDelegate <NSObject>
@optional
//将要消失
- (void)manageTypeSelectViewWillDisappear:(DDManageTypeSelectView*)manageTypeSelectView;
//选择了哪个row
- (void)manageTypeSelectViewSelected:(DDManageTypeSelectView*)manageTypeSelectView pointRow:(NSUInteger)pointRow;
@end

@interface DDManageTypeSelectView : UIView<UITableViewDataSource,UITableViewDelegate>
@property (weak,nonatomic)id <DDManageTypeSelectViewDelegate>delegate;
@property (assign,nonatomic)NSUInteger pointRow;//目标row
- (void)showInView:(UIView*)view;
- (void)hide;
@end

NS_ASSUME_NONNULL_END
