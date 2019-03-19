//
//  DDSearchBusinessInfoListCell.h
//  GongChengDD
//
//  Created by xzx on 2018/9/19.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDSearchBusinessInfoListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDSearchBusinessInfoListCell : UITableViewCell

    @property (weak, nonatomic) IBOutlet UILabel *titleLab;
    @property (weak, nonatomic) IBOutlet UILabel *peopleLab1;
    @property (weak, nonatomic) IBOutlet UILabel *peopleLab2;
    @property (weak, nonatomic) IBOutlet UILabel *dateLab1;
    @property (weak, nonatomic) IBOutlet UILabel *dateLab2;
    @property (weak, nonatomic) IBOutlet UIButton *peopleBtn;
    @property (weak, nonatomic) IBOutlet UILabel *statusLab;
    -(void)loadDataWithModel:(DDSearchBusinessInfoListModel *)model;
    
@end

NS_ASSUME_NONNULL_END
