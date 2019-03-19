//
//  DDCompanyCreditScoreListCell.h
//  GongChengDD
//
//  Created by xzx on 2018/9/19.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDCompanyCreditScoreListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDCompanyCreditScoreListCell : UITableViewCell

    @property (weak, nonatomic) IBOutlet UILabel *nameLab1;
    @property (weak, nonatomic) IBOutlet UILabel *nameLab2;
    @property (weak, nonatomic) IBOutlet UILabel *cityLab1;
    @property (weak, nonatomic) IBOutlet UILabel *cityLab2;
    @property (weak, nonatomic) IBOutlet UILabel *line1;
    @property (weak, nonatomic) IBOutlet UILabel *timeLab1;
    @property (weak, nonatomic) IBOutlet UILabel *timeLab2;
    @property (weak, nonatomic) IBOutlet UILabel *line2;
    @property (weak, nonatomic) IBOutlet UILabel *majorLab1;
    @property (weak, nonatomic) IBOutlet UILabel *majorLab2;
    @property (weak, nonatomic) IBOutlet UILabel *line3;
    @property (weak, nonatomic) IBOutlet UILabel *scoreLab1;
    @property (weak, nonatomic) IBOutlet UILabel *scoreLab2;
@property (weak, nonatomic) IBOutlet UILabel *countName;
@property (weak, nonatomic) IBOutlet UILabel *countNum;
-(void)loadDataWithModel:(DDCompanyCreditScoreListModel *)model;
    
@end

NS_ASSUME_NONNULL_END
