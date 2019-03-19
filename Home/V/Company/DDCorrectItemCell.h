//
//  DDCorrectItemCell.h
//  GongChengDD
//
//  Created by csq on 2018/5/29.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DDCorrectItemCell;
@protocol DDCorrectItemCellDelegate<NSObject>
@optional
/**
 选择了信息错误模块

 @param cell cell description
 @param pointButtonTag 模块tag,如果已经选中,pointButtonTag>0,如果未选中pointButtonTag=0
 */
- (void)selectInfoErrorItem:(DDCorrectItemCell*)cell pointButtonTag:(NSInteger)pointButtonTag;

- (void)selectInfoErroeItem:(DDCorrectItemCell*)cell pointButtonTagArray:(NSArray*)pointButtonTagArray;
@end

@interface DDCorrectItemCell : UITableViewCell
@property (assign,nonatomic)NSInteger pointButtonTag;//选中的按钮tag
@property (strong,nonatomic)NSMutableArray * pointButtonTagArray;
@property (weak,nonatomic)id<DDCorrectItemCellDelegate>delegate;

- (void)loadWithTitles:(NSArray*)titles;
+ (CGFloat)heightWithTitles:(NSArray*)titles;

+ (CGFloat)height;

@end
