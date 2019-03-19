//
//  DDFindingConditionActionCell.h
//  GongChengDD
//
//  Created by csq on 2018/11/6.
//  Copyright © 2018 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDFindingConditionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDFindingConditionActionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *actionButton;

- (void)loadWithModel:(DDFindingConditionModel*)model;

+(CGFloat)height;

@end

NS_ASSUME_NONNULL_END
