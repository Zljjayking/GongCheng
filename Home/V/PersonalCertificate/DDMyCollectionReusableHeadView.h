//
//  DDMyCollectionReusableHeadView.h
//  GongChengDD
//
//  Created by Koncendy on 2017/12/4.
//  Copyright © 2017年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDMyCollectionReusableHeadView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *currentCityWidth;
@property (weak, nonatomic) IBOutlet UIButton *currentCityBtn;
@property (weak, nonatomic) IBOutlet UILabel *seperateLine;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;

@end
