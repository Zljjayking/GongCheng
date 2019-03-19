//
//  DDCompanyList2Cell.h
//  GongChengDD
//
//  Created by xzx on 2018/8/15.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDSearchCompanyListModel.h"
#import "DDMyCollectModel.h"

@interface DDCompanyList2Cell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *areaLab;
@property (weak, nonatomic) IBOutlet UIButton *peopleBtn;
@property (weak, nonatomic) IBOutlet UILabel *statusLab;
@property (weak, nonatomic) IBOutlet UILabel *zzCountLab;
@property (weak, nonatomic) IBOutlet UILabel *ryzsCountLab;
@property (weak, nonatomic) IBOutlet UILabel *zbCountLab;
@property (weak, nonatomic) IBOutlet UILabel *fxxxCountLab;
@property (weak, nonatomic) IBOutlet UILabel *hjryCountLab;
@property (weak, nonatomic) IBOutlet UILabel *xyqkCountLab;

-(void)loadDataWithModel:(DDSearchCompanyListModel *)model;

-(void)loadDataWithModel3:(DDSearchCompanyListModel *)model;
+(CGFloat)height;

-(void)loadDataWithModel2:(DDMyCollectModel *)model;

@end
