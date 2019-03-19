//
//  DDFireEngineerDetail1Cell.h
//  GongChengDD
//
//  Created by xzx on 2018/9/25.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDFireEngineerDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDFireEngineerDetail1Cell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *numberLab1;
@property (weak, nonatomic) IBOutlet UILabel *numberLab2;
@property (weak, nonatomic) IBOutlet UILabel *lineLab;
@property (weak, nonatomic) IBOutlet UILabel *levelLab1;
@property (weak, nonatomic) IBOutlet UILabel *levelLab2;
@property (weak, nonatomic) IBOutlet UILabel *validLab1;
@property (weak, nonatomic) IBOutlet UILabel *validLab2;
@property (weak, nonatomic) IBOutlet UILabel *departLab1;
@property (weak, nonatomic) IBOutlet UILabel *departLab2;
@property (weak, nonatomic) IBOutlet UILabel *nameLab1;
@property (weak, nonatomic) IBOutlet UILabel *nameLab2;
@property (weak, nonatomic) IBOutlet UILabel *addressLab1;
@property (weak, nonatomic) IBOutlet UILabel *addressLab2;
@property (weak, nonatomic) IBOutlet UIButton *makeBtn;
-(void)loadDataWithModel:(DDFireEngineerDetailModel *)model;

@end

NS_ASSUME_NONNULL_END
