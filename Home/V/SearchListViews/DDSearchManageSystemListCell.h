//
//  DDSearchManageSystemListCell.h
//  GongChengDD
//
//  Created by xzx on 2018/9/21.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDSearchManageSystemListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDSearchManageSystemListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *numberLab1;
@property (weak, nonatomic) IBOutlet UILabel *numberLab2;
@property (weak, nonatomic) IBOutlet UILabel *dateLab1;
@property (weak, nonatomic) IBOutlet UILabel *dateLab2;
@property (weak, nonatomic) IBOutlet UILabel *validLab1;
@property (weak, nonatomic) IBOutlet UILabel *validLab2;
-(void)loadDataWithModel:(DDSearchManageSystemListModel *)model;

@end

NS_ASSUME_NONNULL_END
