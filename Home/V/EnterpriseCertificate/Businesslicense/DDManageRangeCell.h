//
//  DDManageRangeCell.h
//  GongChengDD
//
//  Created by csq on 2018/8/10.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 经营范围cell
 */
@interface DDManageRangeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;

- (void)loadWithContent:(NSString*)content showAll:(BOOL)showAll;

- (CGFloat)heightWithContent:(NSString*)content showAll:(BOOL)showAll;

@end
