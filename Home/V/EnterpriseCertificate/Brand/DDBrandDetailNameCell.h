//
//  DDBrandDetailNameCell.h
//  GongChengDD
//
//  Created by csq on 2018/9/25.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDBrandDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDBrandDetailNameCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *topLine;

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;

- (void)loadWithTitle:(NSString*)title content:(NSString*)content;

+(CGFloat)height;

@end

NS_ASSUME_NONNULL_END
