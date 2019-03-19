//
//  DDWorkingLawCell.h
//  GongChengDD
//
//  Created by csq on 2018/9/20.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDWorkingLawModel.h"
/*
 awardYear = "1"
 id = 1;
 number = "1";
 title = "11";
 */
NS_ASSUME_NONNULL_BEGIN

@interface DDWorkingLawCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *numberMarkLab;
@property (weak, nonatomic) IBOutlet UILabel *numberLab;
@property (weak, nonatomic) IBOutlet UILabel *awardYearMarkLab;
@property (weak, nonatomic) IBOutlet UILabel *awardYearLab;

- (void)loadWithModel:(DDWorkingLawModel*)model;
- (CGFloat)height;
@end

NS_ASSUME_NONNULL_END
