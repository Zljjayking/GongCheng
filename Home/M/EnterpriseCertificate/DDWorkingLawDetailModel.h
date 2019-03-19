//
//  DDWorkingLawDetailModel.h
//  GongChengDD
//
//  Created by csq on 2018/9/20.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

/**
 {
 code = 0
 data = {
 awardYear = "1";
 completionEnt = [
 {
 entName = "测试1"
 },
 {
 entName = "测试2"
 }
 ];
 completionPerson = "12313";
 department = "1"
 id = 1;
 number = "1";
 publishDate = "2018-09-19";
 title = "11";
 validityPeriodEnd = "2018-09-19";
 };
 msg = "success";
 }
 */
@protocol DDCompletionEntModel <NSObject>
@end
@interface DDCompletionEntModel : JSONModel
@property (nonatomic,copy) NSString<Optional> *entName;//企业名称
@end

@interface DDWorkingLawDetailModel : JSONModel
@property (nonatomic,copy) NSArray<Optional,DDCompletionEntModel> *completionEnt;//企业列表
@property (nonatomic,copy) NSString<Optional> *awardYear;//授予年度
@property (nonatomic,copy) NSString<Optional> *completionPerson;//完成人
@property (nonatomic,copy) NSString<Optional> *department;//授予部门
@property (nonatomic,copy) NSString<Optional> *id;
@property (nonatomic,copy) NSString<Optional> *number;//编号
@property (nonatomic,copy) NSString<Optional> *publishDate;//发布日期
@property (nonatomic,copy) NSString<Optional> *title;//标题
@property (nonatomic,copy) NSString<Optional> *validityPeriodEnd;//到期时间
@end

NS_ASSUME_NONNULL_END
