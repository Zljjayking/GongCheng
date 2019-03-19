//
//  DDAptitudeCertiListCell.h
//  GongChengDD
//
//  Created by xzx on 2018/12/11.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDAptitudeCertiListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDAptitudeCertiListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *dateLab1;
@property (weak, nonatomic) IBOutlet UILabel *dateLab2;
@property (weak, nonatomic) IBOutlet UILabel *validLab1;
@property (weak, nonatomic) IBOutlet UILabel *validLab2;

-(void)loadDataWithModel:(DDAptitudeContent *)model;

@end

NS_ASSUME_NONNULL_END
