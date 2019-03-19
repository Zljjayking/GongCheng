//
//  DDQRCodeScanModel.h
//  GongChengDD
//
//  Created by xzx on 2018/7/31.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "JSONModel.h"

@interface DDQRCodeScanModel : JSONModel

@property (nonatomic,copy) NSString <Optional> *cdt;
@property (nonatomic,copy) NSString <Optional> *expire;
@property (nonatomic,copy) NSString <Optional> *ticket;

@end
