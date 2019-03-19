//
//  DDSearchCreditScoreListCell.h
//  GongChengDD
//
//  Created by xzx on 2018/9/21.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDSearchCreditScoreListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDSearchCreditScoreListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *majorLab1;
@property (weak, nonatomic) IBOutlet UILabel *majorLab2;
@property (weak, nonatomic) IBOutlet UILabel *scoreLab1;
@property (weak, nonatomic) IBOutlet UILabel *scoreLab2;
-(void)loadDataWithModel:(DDSearchCreditScoreListModel *)model;

@end

NS_ASSUME_NONNULL_END
