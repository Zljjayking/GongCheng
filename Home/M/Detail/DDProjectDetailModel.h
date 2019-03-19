//
//  DDProjectDetailModel.h
//  GongChengDD
//
//  Created by xzx on 2018/5/24.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <JSONModel/JSONModel.h>

/*
 amount = 0;
 hostUrl = <null>;
 image = <null>;
 isCollection = 0;
 mergerName = <null>;
 projectManager = <null>;
 publishDate = "2018-01-29 00:00:00"
 regionId = <null>;
 title = "园林绿化工程 （E3203010319000553002001）";
 tradingCenter = <null>;
 type = <null>;
 winBidOrg = <null>;
 winCaseId = 1342738857132544;
 */

@interface DDProjectDetailModel : JSONModel

@property (nonatomic,copy) NSString <Optional> *amount;
@property (nonatomic,copy) NSString <Optional> *hostUrl;
@property (nonatomic,copy) NSString <Optional> *image;
@property (nonatomic,copy) NSString <Optional> *is_collect;
@property (nonatomic,copy) NSString <Optional> *mergerName;
@property (nonatomic,copy) NSString <Optional> *projectManager;
@property (nonatomic,copy) NSString <Optional> *publishDate;
@property (nonatomic,copy) NSString <Optional> *regionId;
@property (nonatomic,copy) NSString <Optional> *title;
@property (nonatomic,copy) NSString <Optional> *tradingCenter;
@property (nonatomic,copy) NSString <Optional> *type;
@property (nonatomic,copy) NSString <Optional> *winBidOrg;
@property (nonatomic,copy) NSString <Optional> *winCaseId;
@property (nonatomic,copy) NSString <Optional> *projectTypeName;
@property (nonatomic,copy) NSString <Optional> *project_manager;
@property (nonatomic,copy) NSString <Optional> *publish_date;
@property (nonatomic,copy) NSString <Optional> *money_type;
@property (nonatomic,copy) NSString <Optional> *win_bid_text;
@end
