//
//  DDECSummaryHeaderView.h
//  GongChengDD
//
//  Created by csq on 2018/6/5.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DDECSummaryHeaderView;
@protocol DDECSummaryHeaderViewDelagate<NSObject>
@optional
- (void)summaryHeaderViewClick:(DDECSummaryHeaderView*)headview section:(NSInteger)section;

@end

@interface DDECSummaryHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *blueView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *markLab;
@property (weak, nonatomic) IBOutlet UIImageView *arraowImageView;
@property (assign, nonatomic)NSInteger section;
@property (weak, nonatomic)id<DDECSummaryHeaderViewDelagate>delegate;

- (void)loadWithTitle:(NSString*)title mark:(NSString*)mark section:(NSInteger)section;

@end
