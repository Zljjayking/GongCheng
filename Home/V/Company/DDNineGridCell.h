//
//  DDNineGridCell.h
//  Certificate
//
//  Created by csq on 2017/7/6.
//  Copyright © 2017年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDCompanyDetailModel2.h"

@class DDNineGridCell;
@protocol DDNineGridCellDelegate <NSObject>
@optional

- (void)nineGridCell:(DDNineGridCell*)nineGridCell index:(NSInteger)index;

@end

@interface DDNineGridCell : UITableViewCell
@property(weak,nonatomic)id<DDNineGridCellDelegate>delegate;

- (void)loadCellWithImageArray:(NSArray*)imageArray andArray:(NSArray <DDSubModel *> *)array;
+(CGFloat)heightWithArrayNum:(NSInteger)arrayNum;

@end
