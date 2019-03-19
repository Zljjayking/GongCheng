//
//  DDFinishUnitCell.h
//  GongChengDD
//
//  Created by csq on 2018/9/20.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDFinishUnitCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *contentLab;

- (void)loadWithContent:(NSString*)content;

- (CGFloat)height;
@end

NS_ASSUME_NONNULL_END
