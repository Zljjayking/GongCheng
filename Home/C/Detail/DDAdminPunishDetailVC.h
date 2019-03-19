//
//  DDAdminPunishDetailVC.h
//  GongChengDD
//
//  Created by xzx on 2018/6/4.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 行政处罚详情
 */
@interface DDAdminPunishDetailVC : UIViewController

@property (nonatomic,strong) NSString *punish_id;//行政处罚Id
@property (nonatomic,strong) NSString *punishType;//1表示环保处罚，2表示工地处罚

@end
