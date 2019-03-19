//
//  DDSafeManCell.h
//  GongChengDD
//
//  Created by xzx on 2018/9/26.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDCompanySafemanModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDSafeManCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *typeLab1;
@property (weak, nonatomic) IBOutlet UILabel *typeLab2;
@property (weak, nonatomic) IBOutlet UILabel *numberLab1;
@property (weak, nonatomic) IBOutlet UILabel *numberLab2;
@property (weak, nonatomic) IBOutlet UILabel *statusLab1;
@property (weak, nonatomic) IBOutlet UILabel *statusLab2;
@property (weak, nonatomic) IBOutlet UILabel *validLab1;
@property (weak, nonatomic) IBOutlet UILabel *validLab2;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
-(void)loadDataWithModel:(DDCompanySafemanModel *)model andIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
