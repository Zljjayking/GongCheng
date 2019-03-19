//
//  DDArchitectCell.h
//  GongChengDD
//
//  Created by csq on 2018/9/21.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDArchitectModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDArchitectCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *scoreLab1;
@property (weak, nonatomic) IBOutlet UILabel *scoreLab2;
@property (weak, nonatomic) IBOutlet UILabel *numberLab1;
@property (weak, nonatomic) IBOutlet UILabel *numberLab2;
@property (weak, nonatomic) IBOutlet UILabel *registerLab1;
@property (weak, nonatomic) IBOutlet UILabel *registerLab2;
@property (weak, nonatomic) IBOutlet UILabel *validLab1;
@property (weak, nonatomic) IBOutlet UILabel *validLab2;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;

- (void)loadDataWithModel:(DDArchitectModel *)model andIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
