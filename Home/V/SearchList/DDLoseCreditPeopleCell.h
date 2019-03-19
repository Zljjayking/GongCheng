//
//  DDLoseCreditPeopleCell.h
//  GongChengDD
//
//  Created by xzx on 2018/8/20.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDSerarchExcutedPeopleListModel.h"

@interface DDLoseCreditPeopleCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *numLab1;
@property (weak, nonatomic) IBOutlet UILabel *numLab2;
@property (weak, nonatomic) IBOutlet UILabel *courtLab1;
@property (weak, nonatomic) IBOutlet UILabel *courtLab2;
@property (weak, nonatomic) IBOutlet UILabel *timeLab1;
@property (weak, nonatomic) IBOutlet UILabel *timeLab2;

-(void)loadDataWithModel:(DDSerarchExcutedPeopleListModel *)model;

@end
