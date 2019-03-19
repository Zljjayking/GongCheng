//
//  DDCorrectInputCell.h
//  GongChengDD
//
//  Created by csq on 2018/5/29.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DDCorrectInputCell;
@protocol DDCorrectInputCellDerlagate<NSObject>
//输入框内容已经改变
- (void)correctInputCellDidChange:(DDCorrectInputCell*)cell text:(NSString*)text;
@end

@interface DDCorrectInputCell : UITableViewCell<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet UITextView *inputTextView;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLab;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (copy, nonatomic) NSString * summary;//内容

@property (weak, nonatomic) id<DDCorrectInputCellDerlagate>delegate;

+(CGFloat)height;

@end
