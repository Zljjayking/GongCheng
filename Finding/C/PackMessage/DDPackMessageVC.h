//
//  DDPackMessageVC.h
//  GongChengDD
//
//  Created by csq on 2019/1/4.
//  Copyright © 2019 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDPackMessageVC : UIViewController
@property (nonatomic,copy) NSString *IDstr;
@property (nonatomic,copy) NSString *enterpriseName;
/// 到期提醒
@property (nonatomic,copy) NSString *daoqitixingStr;
///时间
@property (nonatomic,copy) NSString *updateTimeString;



@end

NS_ASSUME_NONNULL_END
