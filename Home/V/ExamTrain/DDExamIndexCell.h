//
//  DDExamIndexCell.h
//  GongChengDD
//
//  Created by hou qiangqiang on 2019/2/21.
//  Copyright © 2019 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DDExamIndexCellDelegate <NSObject>

-(void)hasClickedWithSection:(NSInteger)secIndex andRow:(NSInteger)rowIndex;

@end

NS_ASSUME_NONNULL_BEGIN

@interface DDExamIndexCell : UITableViewCell
@property(nonatomic,strong) UILabel *titleL;
@property(nonatomic,strong) UILabel *lineL;
@property(nonatomic,strong) NSArray *indexArr;
@property(nonatomic,assign) NSInteger sectionIndex;
@property(nonatomic,weak)id <DDExamIndexCellDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
