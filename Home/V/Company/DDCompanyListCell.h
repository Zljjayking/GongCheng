//
//  DDCompanyListCell.h
//  GongChengDD
//
//  Created by xzx on 2018/5/15.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDSearchCompanyListModel.h"

@interface DDCompanyListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *areaLab;
@property (weak, nonatomic) IBOutlet UIButton *peopleBtn;
@property (weak, nonatomic) IBOutlet UILabel *descLab;
@property (weak, nonatomic) IBOutlet UILabel *statusLab;

-(void)loadDataWithModel:(DDSearchCompanyListModel *)model;

@end
