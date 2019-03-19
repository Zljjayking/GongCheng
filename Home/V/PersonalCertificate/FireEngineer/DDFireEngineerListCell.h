//
//  DDFireEngineerListCell.h
//  GongChengDD
//
//  Created by xzx on 2018/9/25.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDFireEngineerListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDFireEngineerListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *numberLab1;
@property (weak, nonatomic) IBOutlet UILabel *numberLab2;
@property (weak, nonatomic) IBOutlet UILabel *levelLab1;
@property (weak, nonatomic) IBOutlet UILabel *levelLab2;
@property (weak, nonatomic) IBOutlet UILabel *validLab1;
@property (weak, nonatomic) IBOutlet UILabel *validLab2;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
-(void)loadDataWithModel:(DDFireEngineerListModel *)model andIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
