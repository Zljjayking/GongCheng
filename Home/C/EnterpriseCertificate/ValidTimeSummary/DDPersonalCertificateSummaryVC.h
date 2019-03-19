//
//  DDPersonalCertificateSummaryVC.h
//  GongChengDD
//
//  Created by csq on 2017/12/4.
//  Copyright © 2017年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDPersonalCertificateSummaryVC : UIViewController

@property (weak,nonatomic)UIViewController * mainViewContoller;
/**
 企业id
 */
@property (nonatomic,copy)NSString * enterpriseId;
@end
