//
//  DDAllTypesModel.h
//  GongChengDD
//
//  Created by xzx on 2018/5/21.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface DDAllTypesModel : JSONModel

/*
 iconFileId = 8;
 menuId = 17
 name = "安许证";
*/
@property (nonatomic, copy) NSString <Optional> *menuId;
@property (nonatomic, copy) NSString <Optional> *name;
@property (nonatomic, copy) NSString <Optional> *iconFileId;

@end
