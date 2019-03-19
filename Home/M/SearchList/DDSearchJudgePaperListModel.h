//
//  DDSearchJudgePaperListModel.h
//  GongChengDD
//
//  Created by xzx on 2018/6/4.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface DDSearchJudgePaperListModel : JSONModel

/*
 enterprise_id = 1229292237947136;
 enterprise_name = "江苏康森迪信息科技有限公司";
 judgment_case_number = "（2014）民抗字第48号"
 judgment_id = 2;
 judgment_identity = "被告：。。。。。。";
 judgment_publish_date = "2018-05-27";
 judgment_title = "丹东通宇<font color='red'>建筑</font>工程公司与丹东客来多购物广场有限公司、丹东市金源房地产开发有限公司债权人撤销权纠纷审判监督民事判决书";
 */

@property (nonatomic, copy) NSString <Optional> *enterprise_id;
@property (nonatomic, copy) NSString <Optional> *enterprise_name;
@property (nonatomic, copy) NSString <Optional> *judgment_case_number;
@property (nonatomic, copy) NSString <Optional> *judgment_id;
@property (nonatomic, copy) NSString <Optional> *judgment_identity;
@property (nonatomic, copy) NSString <Optional> *judgment_publish_date;
@property (nonatomic, copy) NSString <Optional> *judgment_title;
@property (nonatomic, copy) NSString <Optional> *court;

@property (nonatomic, copy) NSAttributedString <Optional> *titleAttriStr;
@property (nonatomic, copy) NSAttributedString <Optional> *enterpriseNameStr;

@end
