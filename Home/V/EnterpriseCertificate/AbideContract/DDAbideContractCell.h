//
//  DDAbideContractCell.h
//  GongChengDD
//
//  Created by csq on 2018/9/19.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDDAbideContractModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDAbideContractCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *enterpriseNameLab;
@property (weak, nonatomic) IBOutlet UILabel *publishDateLab;
@property (weak, nonatomic) IBOutlet UILabel *publisherLab;

- (void)loadWithModel:(DDDAbideContractModel*)model;
- (CGFloat)height;

@end

NS_ASSUME_NONNULL_END
