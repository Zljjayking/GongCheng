//
//  DDBrandDetailHeaderCell.h
//  GongChengDD
//
//  Created by csq on 2018/9/25.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDBrandDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDBrandDetailHeaderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *brandImageView;

- (void)loadWithModel:(DDBrandDetailModel*)model;

+(CGFloat)height;

@end

NS_ASSUME_NONNULL_END
