//
//  DDWorkingLawModel.h
//  GongChengDD
//
//  Created by csq on 2018/9/20.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

/*
 awardYear = "2015-2016国家级"
 id = 19;
 number = "CK45783-23823";
 publishDate = "2010-10-13";
 title = "测试施工工法记录";
 */
@interface DDWorkingLawModel : JSONModel
@property (nonatomic,copy) NSString<Optional> *awardYear;
@property (nonatomic,copy) NSString<Optional> *id;
@property (nonatomic,copy) NSString<Optional> *number;
@property (nonatomic,copy) NSString<Optional> *title;

@end

NS_ASSUME_NONNULL_END
