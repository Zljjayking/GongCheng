//
//  DDAptitudeCerContentCell.h
//  GongChengDD
//
//  Created by csq on 2018/5/25.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDAptitudeCerModel.h"


@interface DDAptitudeCerContentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
//@property (weak, nonatomic) IBOutlet UILabel *subTitleLab;
//@property (weak, nonatomic) IBOutlet UIView *line;

- (void)loadWithModel:(DDSubitemModel*)model;

+(CGFloat)height;

@end
