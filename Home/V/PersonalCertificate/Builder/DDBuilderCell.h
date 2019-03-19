//
//  DDBuilderCell.h
//  GongChengDD
//
//  Created by xzx on 2018/5/17.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDCompanyBuilderModel.h"

@interface DDBuilderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *enterImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *roleLab;

@property (weak, nonatomic) IBOutlet UILabel *leftLab;
@property (weak, nonatomic) IBOutlet UILabel *bidNumLab;

@property (weak, nonatomic) IBOutlet UILabel *registerLab1;
@property (weak, nonatomic) IBOutlet UILabel *registerLab2;
@property (weak, nonatomic) IBOutlet UILabel *majorLab1;
@property (weak, nonatomic) IBOutlet UILabel *majorLab2;
@property (weak, nonatomic) IBOutlet UILabel *numLab1;
@property (weak, nonatomic) IBOutlet UILabel *numLab2;
@property (weak, nonatomic) IBOutlet UILabel *isBLab1;
@property (weak, nonatomic) IBOutlet UILabel *isBLab2;
@property (weak, nonatomic) IBOutlet UILabel *timeLab1;
@property (weak, nonatomic) IBOutlet UILabel *timeLab2;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;

-(void)loadDataWithModel:(DDCompanyBuilderModel *)model andIndex:(NSInteger)index;

@end
