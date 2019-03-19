//
//  DDBrandDetailTwoTitleCell.h
//  GongChengDD
//
//  Created by csq on 2018/9/25.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDBrandDetailTwoTitleCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *topLine;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UIImageView *arrow;

- (void)loadWithTitle:(NSString*)title content:(NSString*)content;

- (CGFloat)height;

@end

NS_ASSUME_NONNULL_END
