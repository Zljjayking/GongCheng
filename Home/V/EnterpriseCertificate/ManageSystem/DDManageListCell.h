//
//  DDManageListCell.h
//  GongChengDD
//
//  Created by csq on 2018/9/19.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDManageListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDManageListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *authProjectLab;
@property (weak, nonatomic) IBOutlet UILabel *cerNumMarkLab;
@property (weak, nonatomic) IBOutlet UILabel *cerNumLab;
@property (weak, nonatomic) IBOutlet UILabel *postCertDateMarkLab;
@property (weak, nonatomic) IBOutlet UILabel *postCertDateLab;
@property (weak, nonatomic) IBOutlet UILabel *certEndDateMarkLab;
@property (weak, nonatomic) IBOutlet UILabel *certEndDateLab;
//@property (weak, nonatomic) IBOutlet UIView *line;

- (void)loadWithModel:(DDManageListModel*)model;
- (CGFloat)height;

@end

NS_ASSUME_NONNULL_END
