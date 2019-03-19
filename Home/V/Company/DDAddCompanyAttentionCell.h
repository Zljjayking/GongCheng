//
//  DDAddCompanyAttentionCell.h
//  GongChengDD
//
//  Created by csq on 2018/5/25.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDAddCompanyAttentionCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;

- (void)loadWithTitle:(NSString*)title isSelected:(BOOL)isSelected;

@end
