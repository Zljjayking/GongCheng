//
//  DDOpenContactWayVC.h
//  GongChengDD
//
//  Created by xzx on 2018/11/29.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum: NSInteger{
    OpenContactWayTypeDefault=0,
    OpenContactWayTypeOther = 1,
}DDOpenContactWayType;


NS_ASSUME_NONNULL_BEGIN

@interface DDOpenContactWayVC : UIViewController

@property (nonatomic,strong) NSString *staffInfoId;//人员id
@property (nonatomic,strong) NSString *phoneStr;//手机号码
@property (nonatomic,assign) DDOpenContactWayType openContactWayType;

@end

NS_ASSUME_NONNULL_END
