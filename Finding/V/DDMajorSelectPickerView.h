//
//  DDMajorSelectPickerView.h
//  GongChengDD
//
//  Created by csq on 2018/11/6.
//  Copyright © 2018 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DDMajorSelectPickerView;
@protocol DDMajorSelectPickerViewDelegate <NSObject>
@optional
//选中了某一行
- (void)majorSelectPickerViewClickFinsh:(DDMajorSelectPickerView*)majorSelectPickerView row:(NSInteger)row;
@end

@interface DDMajorSelectPickerView : UIView<UIPickerViewDataSource,UIPickerViewDelegate>
@property (nonatomic,strong)NSMutableArray * titleArr;
@property (nonatomic,assign)NSInteger  firstComponentSelectRow;
@property (nonatomic,weak)id<DDMajorSelectPickerViewDelegate>delegate;

- (void)loadWithTitle:(NSString*)title dataArray:(NSArray*)dataArray;
-(void)show;
- (void)hide;

@end

NS_ASSUME_NONNULL_END
