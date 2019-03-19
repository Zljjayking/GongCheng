//
//  DDCivilEngineerCell.h
//  GongChengDD
//
//  Created by xzx on 2018/9/26.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDCivilEngineerModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDCivilEngineerCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *scoreLab1;
@property (weak, nonatomic) IBOutlet UILabel *scoreLab2;
@property (weak, nonatomic) IBOutlet UILabel *majorLab1;
@property (weak, nonatomic) IBOutlet UILabel *majorLab2;
@property (weak, nonatomic) IBOutlet UILabel *numberLab1;
@property (weak, nonatomic) IBOutlet UILabel *numberLab2;
@property (weak, nonatomic) IBOutlet UILabel *registerLab1;
@property (weak, nonatomic) IBOutlet UILabel *registerLab2;
@property (weak, nonatomic) IBOutlet UILabel *validLab1;
@property (weak, nonatomic) IBOutlet UILabel *validLab2;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;

- (void)loadDataWithModel:(DDCivilEngineerModel *)model andIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
