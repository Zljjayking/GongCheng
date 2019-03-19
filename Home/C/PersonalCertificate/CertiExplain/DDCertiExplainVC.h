//
//  DDCertiExplainVC.h
//  GongChengDD
//
//  Created by xzx on 2018/9/28.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDCertiExplainVC : UIViewController

@property (nonatomic,strong) NSString *peopleName;//人员姓名
@property (nonatomic,strong) NSString *certType;//1一级建造师、二级建造师 2安全员 3一级结构师 4二级结构师 5化工工程师 6一级建筑师 7二级建筑师 8土木工程师 9公用设备师 10电气工程师 11监理工程师 12造价工程师 13消防工程师
@property (nonatomic,strong) NSString *certId;//证书Id

@end

NS_ASSUME_NONNULL_END
