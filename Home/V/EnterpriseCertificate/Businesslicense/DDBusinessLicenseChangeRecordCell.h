//
//  DDBusinessLicenseChangeRecordCell.h
//  GongChengDD
//
//  Created by csq on 2018/7/3.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDBusinessLicenseChangeModel.h"

@interface DDBusinessLicenseChangeRecordCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UILabel *beforeTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *beforeContentLab;

@property (weak, nonatomic) IBOutlet UIView *centreLine;

@property (weak, nonatomic) IBOutlet UILabel *afterTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *afterContentLab;


- (void)loadWithModel:(DDBusinessLicenseChangeModel*)model;

+ (CGFloat)heightWithModel:(DDBusinessLicenseChangeModel*)model;

@end
