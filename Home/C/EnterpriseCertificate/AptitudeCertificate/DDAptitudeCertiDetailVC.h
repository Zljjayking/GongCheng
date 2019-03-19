//
//  DDAptitudeCertiDetailVC.h
//  GongChengDD
//
//  Created by xzx on 2018/12/11.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDAptitudeCertiDetailVC : UIViewController

@property (nonatomic,copy) NSString *certNo;
@property (nonatomic,copy) NSString *issuedDate;
@property (nonatomic,copy) NSString *validityPeriodEnd;
@property (nonatomic,copy) NSString *issuedDeptSource;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *certTypeId;
@property (nonatomic,copy) NSString *majorCategory;
@end

NS_ASSUME_NONNULL_END
