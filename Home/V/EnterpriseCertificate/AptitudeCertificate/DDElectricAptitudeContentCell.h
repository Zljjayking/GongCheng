//
//  DDElectricAptitudeContentCell.h
//  GongChengDD
//
//  Created by csq on 2018/8/24.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDAptitudeCerModel.h"

/**
 电力资质cell
 */
@interface DDElectricAptitudeContentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLab;

- (void)loadWithModel:(DDSubitemModel*)model;

+ (CGFloat)height;

@end
