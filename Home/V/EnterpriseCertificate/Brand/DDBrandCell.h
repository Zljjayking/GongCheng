//
//  DDBrandCell.h
//  GongChengDD
//
//  Created by csq on 2018/9/20.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDBrandModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDBrandCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *statesLab;
@property (weak, nonatomic) IBOutlet UILabel *registerNumLab;
@property (weak, nonatomic) IBOutlet UILabel *applyDateLab;
@property (weak, nonatomic) IBOutlet UILabel *typeLab;
@property (weak, nonatomic) IBOutlet UIImageView *arrow;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statesLabWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statesLabHeight;


- (void)loadWithModel:(DDBrandListModel*)model;
- (CGFloat)height;

@end

NS_ASSUME_NONNULL_END
