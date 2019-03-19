//
//  DDValidityView.h
//  GongChengDD
//
//  Created by Koncendy on 2017/10/23.
//  Copyright © 2017年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DDValidityViewDelegate <NSObject>
-(void)validityViewButtonAction;
@end

@interface DDValidityView : UIView

@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIButton    *dateBtn;
@property (nonatomic, weak) id <DDValidityViewDelegate> delegate;

-(NSString *)loadViewWithTimeType:(NSString*)timeType;

@end
