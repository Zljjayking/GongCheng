//
//  DDCourtNoticeCell.h
//  GongChengDD
//
//  Created by xzx on 2018/5/17.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDSearchCourtNoticeListModel.h"

@interface DDCourtNoticeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *typeLab1;
@property (weak, nonatomic) IBOutlet UILabel *typeLab2;
@property (weak, nonatomic) IBOutlet UILabel *peopleLab1;
@property (weak, nonatomic) IBOutlet UILabel *peopleLab2;
@property (weak, nonatomic) IBOutlet UILabel *timeLab1;
@property (weak, nonatomic) IBOutlet UILabel *timeLab2;

-(void)loadDataWithModel:(DDSearchCourtNoticeListModel *)model;

@end
