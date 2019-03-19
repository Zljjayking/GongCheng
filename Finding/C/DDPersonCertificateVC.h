//
//  DDPersonCertificateVC.h
//  GongChengDD
//
//  Created by csq on 2018/11/6.
//  Copyright © 2018 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDMajorSelectModel.h"

NS_ASSUME_NONNULL_BEGIN

/**
 选择专业完毕

 @param cerName 证书名称
 @param majorModel 专业模型
 @param cerType 证书type
 @param row 目标行
 */
typedef void(^PersonCertificatSelectSuccessBlock)(NSString*cerName,DDMajorSelectModel * majorModel,NSString*cerType,NSInteger pointRow);

@interface DDPersonCertificateVC : UIViewController
@property (nonatomic,assign)NSInteger pointRow;//之前已经选中的行,用来高亮
//选择专业完毕
@property (nonatomic,copy)PersonCertificatSelectSuccessBlock personCertificatSelectSuccessBlock;

@end

NS_ASSUME_NONNULL_END
