//
//  DDBrandDetailSeversCell.h
//  GongChengDD
//
//  Created by csq on 2018/9/25.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDBrandDetailSeversCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;

- (void)loadWithTitle:(NSString*)title;

+ (CGFloat)height;

@end

NS_ASSUME_NONNULL_END
