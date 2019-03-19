//
//  DDMajorModel.h
//  GongChengDD
//
//  Created by Koncendy on 2017/10/9.
//  Copyright © 2017年 Koncendy. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface DDMajorModel : JSONModel

@property (nonatomic,copy)NSString <Optional> *id;
@property (nonatomic,copy)NSString <Optional> *name;
@property (nonatomic,copy)NSString <Optional> *sort;

@end
