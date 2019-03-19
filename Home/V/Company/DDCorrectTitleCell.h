//
//  DDCorrectTitleCell.h
//  GongChengDD
//
//  Created by csq on 2018/5/29.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDCorrectTitleCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLab;

- (void)loadWithTitle:(NSString*)title subTitle:(NSString*)subTitle;
@end
