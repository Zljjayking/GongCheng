//
//  DDJudgePaperDetailModel.h
//  GongChengDD
//
//  Created by xzx on 2018/6/7.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface DDJudgePaperDetailModel : JSONModel

/*
 enterpriseName = "江苏康森迪信息科技有限公司";
 judgmentCaseNumber = "（2013）民抗字第48号";
 judgmentExplain = <null>;
 judgmentIdentity = "原告：。。。。。。";
 judgmentOriginalHref = <null>;
 judgmentOriginalImg = <null>;
 judgmentPublishDate = "2019-05-29";
 judgmentTitle = "丹东通宇建筑工程公司与丹东客来多购物广场有限公司"
 region = "江苏省";
 };
 */

@property (nonatomic,copy) NSString <Optional> *enterpriseName;
@property (nonatomic,copy) NSString <Optional> *judgmentCaseNumber;
@property (nonatomic,copy) NSString <Optional> *judgmentExplain;
@property (nonatomic,copy) NSString <Optional> *judgmentIdentity;
@property (nonatomic,copy) NSString <Optional> *judgmentOriginalHref;
@property (nonatomic,copy) NSString <Optional> *judgmentOriginalImg;
@property (nonatomic,copy) NSString <Optional> *judgmentPublishDate;
@property (nonatomic,copy) NSString <Optional> *judgmentTitle;
@property (nonatomic,copy) NSString <Optional> *region;
@property (nonatomic,copy) NSString <Optional> *court;

@end
