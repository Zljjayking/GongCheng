//
//  DDCorrectCompanyInfoTopCell.h
//  GongChengDD
//
//  Created by csq on 2018/5/29.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DDCorrectCompanyInfoTopCell;
@protocol DDCorrectCompanyInfoTopCellDelegate<NSObject>
- (void)actionButtonClick:(DDCorrectCompanyInfoTopCell*)Cell;
@end

@interface DDCorrectCompanyInfoTopCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;
@property (weak, nonatomic) IBOutlet UIView *line;

@property (weak, nonatomic) id <DDCorrectCompanyInfoTopCellDelegate>delegate;

@end
