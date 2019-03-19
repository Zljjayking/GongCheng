//
//  DDSearchAccidentSituationListCell.h
//  GongChengDD
//
//  Created by xzx on 2018/10/31.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDSearchAccidentSituationListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDSearchAccidentSituationListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *serveContentLab;
@property (weak, nonatomic) IBOutlet UILabel *deptLab1;
@property (weak, nonatomic) IBOutlet UILabel *deptLab2;
@property (weak, nonatomic) IBOutlet UILabel *timeLab1;
@property (weak, nonatomic) IBOutlet UILabel *timeLab2;
@property (weak, nonatomic) IBOutlet UIButton *peopleBtn;

//加载数据
-(void)loadDataWithModel:(DDSearchAccidentSituationListModel *)model;

@end

NS_ASSUME_NONNULL_END
