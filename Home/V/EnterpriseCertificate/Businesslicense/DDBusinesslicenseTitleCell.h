//
//  DDBusinesslicenseTitleCell.h
//  GongChengDD
//
//  Created by csq on 2018/8/10.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDBusinesslicenseTitleCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *topLine;//顶部线条,默认隐藏
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;//底部线条,默认隐藏


- (void)loadWithContent:(NSString*)content;

+ (CGFloat)heightWithContent:(NSString*)content;

- (CGFloat)height;

@end
