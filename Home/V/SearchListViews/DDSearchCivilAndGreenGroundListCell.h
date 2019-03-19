//
//  DDSearchCivilAndGreenGroundListCell.h
//  GongChengDD
//
//  Created by xzx on 2018/9/21.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDSearchCivilAndGreenGroundListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDSearchCivilAndGreenGroundListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *managerLab1;
@property (weak, nonatomic) IBOutlet UILabel *managerLab2;
@property (weak, nonatomic) IBOutlet UILabel *agencyLab1;
@property (weak, nonatomic) IBOutlet UILabel *agencyLab2;
@property (weak, nonatomic) IBOutlet UILabel *timeLab1;
@property (weak, nonatomic) IBOutlet UILabel *timeLab2;
-(void)loadDataWithModel:(DDSearchCivilAndGreenGroundListModel *)model;

@end

NS_ASSUME_NONNULL_END
