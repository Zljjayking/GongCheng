//
//  DDJudgePaperDetailCell.h
//  GongChengDD
//
//  Created by xzx on 2018/8/8.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDJudgePaperDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *distanceToTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *distanceToBottom;
@property (weak, nonatomic) IBOutlet UILabel *tipLab;

@end
