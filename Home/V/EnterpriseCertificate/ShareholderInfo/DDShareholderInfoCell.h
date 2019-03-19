//
//  DDShareholderInfoCell.h
//  GongChengDD
//
//  Created by csq on 2018/10/19.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDDDShareholderInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDShareholderInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *holderNameLab;
@property (weak, nonatomic) IBOutlet UIView *bgView1;
@property (weak, nonatomic) IBOutlet UILabel *paidPercentMarkLab;
@property (weak, nonatomic) IBOutlet UILabel *paidPercentLab;
@property (weak, nonatomic) IBOutlet UIView *line1;
@property (weak, nonatomic) IBOutlet UILabel *holderTypeMarkLab;
@property (weak, nonatomic) IBOutlet UILabel *holderTypeLab;

@property (weak, nonatomic) IBOutlet UILabel *amountMrakLab;
@property (weak, nonatomic) IBOutlet UILabel *amountLab;
@property (weak, nonatomic) IBOutlet UILabel *dateMarkLab;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UIView *line2;


@property (weak, nonatomic) IBOutlet UIView *bgView2;

- (void)loadWithModel:(DDDDShareholderInfoModel*)model indexPath:(NSIndexPath*)indexPath;

@end

NS_ASSUME_NONNULL_END
