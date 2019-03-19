//
//  DDExcutedPropleCell.h
//  GongChengDD
//
//  Created by xzx on 2018/5/17.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDSerarchExcutedPeopleListModel.h"

@interface DDExcutedPropleCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *numLab1;
@property (weak, nonatomic) IBOutlet UILabel *numLab2;
@property (weak, nonatomic) IBOutlet UILabel *aimLab1;
@property (weak, nonatomic) IBOutlet UILabel *aimLab2;
@property (weak, nonatomic) IBOutlet UILabel *courtLab1;
@property (weak, nonatomic) IBOutlet UILabel *courtLab2;
@property (weak, nonatomic) IBOutlet UILabel *timeLab1;
@property (weak, nonatomic) IBOutlet UILabel *timeLab2;

-(void)loadDataWithModel:(DDSerarchExcutedPeopleListModel *)model;

@end
