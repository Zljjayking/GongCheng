//
//  DDBranchInfoCell.h
//  GongChengDD
//
//  Created by csq on 2018/10/23.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDBranchInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

- (void)loadWithTitle:(NSString*)title;

-(CGFloat)height;

@end

NS_ASSUME_NONNULL_END
