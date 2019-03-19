//
//  DDAdminPunishCell.h
//  GongChengDD
//
//  Created by xzx on 2018/5/17.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDAdminPunishCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *serveContentLab;
@property (weak, nonatomic) IBOutlet UILabel *deptLab1;
@property (weak, nonatomic) IBOutlet UILabel *deptLab2;
@property (weak, nonatomic) IBOutlet UILabel *timeLab1;
@property (weak, nonatomic) IBOutlet UILabel *timeLab2;
@property (weak, nonatomic) IBOutlet UIButton *peopleBtn;

//加载数据
-(void)loadDataWithContent:(NSString *)content andDept:(NSString *)dept andTime:(NSString *)time;

@end
