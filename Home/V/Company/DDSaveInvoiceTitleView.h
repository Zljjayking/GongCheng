//
//  DDSaveInvoiceTitleView.h
//  GongChengDD
//
//  Created by csq on 2018/10/25.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDInvoiceTitleModel.h"

NS_ASSUME_NONNULL_BEGIN

@class DDSaveInvoiceTitleView;
@protocol DDSaveInvoiceTitleViewDelegate <NSObject>
@optional
//点击了"保存至发票"
- (void)saveInvoiceTitleViewClickSure:(DDSaveInvoiceTitleView*)saveInvoiceTitleView;

@end

@interface DDSaveInvoiceTitleView : UIView
@property (nonatomic,weak)id<DDSaveInvoiceTitleViewDelegate>delegate;
-(void)loadWithInvoiceTitleModel:(DDInvoiceTitleModel*)invoiceTitleModel;
-(void)show;
- (void)hide;

@end

NS_ASSUME_NONNULL_END
