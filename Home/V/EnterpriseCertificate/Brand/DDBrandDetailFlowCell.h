//
//  DDBrandDetailFlowCell.h
//  GongChengDD
//
//  Created by csq on 2018/9/25.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDBrandDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDBrandDetailFlowCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *topLine;
@property (weak, nonatomic) IBOutlet UIImageView *markImageView;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *stateLab;

- (void)loadWithModel:(DDBrandDetailFlowsModel*)model indexPath:(NSIndexPath *)indexPath;
+ (CGFloat)height;

@end

NS_ASSUME_NONNULL_END
