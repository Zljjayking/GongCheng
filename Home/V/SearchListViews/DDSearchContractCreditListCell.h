//
//  DDSearchContractCreditListCell.h
//  GongChengDD
//
//  Created by xzx on 2018/9/20.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDSearchContractCreditListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDSearchContractCreditListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *numberLab1;
@property (weak, nonatomic) IBOutlet UILabel *numberLab2;
@property (weak, nonatomic) IBOutlet UILabel *yearLab1;
@property (weak, nonatomic) IBOutlet UILabel *yearLab2;
-(void)loadDataWithModel:(DDSearchContractCreditListModel *)model;

@end

NS_ASSUME_NONNULL_END
