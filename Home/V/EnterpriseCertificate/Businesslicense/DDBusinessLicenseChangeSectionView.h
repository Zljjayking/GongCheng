//
//  DDBusinessLicenseChangeSectionView.h
//  GongChengDD
//
//  Created by csq on 2018/8/6.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDBusinessLicenseChangeModel.h"

@interface DDBusinessLicenseChangeSectionView : UIView
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;

- (void)loadWithModel:(DDBusinessLicenseChangeModel*)model section:(NSInteger)section;
- (void)loadWithModel2:(DDBusinessLicenseChangeModel*)model section:(NSInteger)section;

+ (CGFloat)height;

- (CGFloat)height;

@end
