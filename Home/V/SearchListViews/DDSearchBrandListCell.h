//
//  DDSearchBrandListCell.h
//  GongChengDD
//
//  Created by xzx on 2018/9/25.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDSearchBrandListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDSearchBrandListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *brandImg;
@property (weak, nonatomic) IBOutlet UILabel *brandTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *tipLab;
@property (weak, nonatomic) IBOutlet UILabel *numberLab1;
@property (weak, nonatomic) IBOutlet UILabel *numberLab2;
@property (weak, nonatomic) IBOutlet UILabel *timeLab1;
@property (weak, nonatomic) IBOutlet UILabel *timeLab2;
@property (weak, nonatomic) IBOutlet UILabel *typeLab1;
@property (weak, nonatomic) IBOutlet UILabel *typeLab2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *distanceUp;
-(void)loadDataWithModel:(DDSearchBrandListModel *)model;

@end

NS_ASSUME_NONNULL_END
