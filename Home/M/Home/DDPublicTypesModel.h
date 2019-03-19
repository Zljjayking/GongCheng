//
//  DDPublicTypesModel.h
//  GongChengDD
//
//  Created by xzx on 2018/5/29.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface DDPublicTypesModel : JSONModel

@property (nonatomic, copy) NSString <Optional> *menuId;
@property (nonatomic, copy) NSString <Optional> *name;
//@property (nonatomic, copy) NSString <Optional> *url;
//@property (nonatomic, copy) NSString <Optional> *urlThumb;
@property (nonatomic, copy) NSString <Optional> *iconFileId;
@property (nonatomic, copy) NSString <Optional> *type;//0表示没有右上角图标，1表示减，2表示加

@end
