//
//  DDPeopleListCell.h
//  GongChengDD
//
//  Created by xzx on 2018/5/21.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDSearchPeopleListModel.h"

@interface DDPeopleListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UIView *btnsView;

-(void)loadDataWithModel:(DDSearchPeopleListModel *)model;

@end
