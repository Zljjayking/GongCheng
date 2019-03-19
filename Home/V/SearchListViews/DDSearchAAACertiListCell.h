//
//  DDSearchAAACertiListCell.h
//  GongChengDD
//
//  Created by xzx on 2018/9/21.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDSearchAAACertiListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDSearchAAACertiListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *gradeLab1;
@property (weak, nonatomic) IBOutlet UILabel *gradeLab2;
@property (weak, nonatomic) IBOutlet UILabel *dateLab1;
@property (weak, nonatomic) IBOutlet UILabel *dateLab2;
-(void)loadDataWithModel:(DDSearchAAACertiListModel *)model;

@end

NS_ASSUME_NONNULL_END
