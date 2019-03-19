//
//  DDCourtNoticeDetailModel.h
//  GongChengDD
//
//  Created by xzx on 2018/6/6.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface DDCourtNoticeDetailModel : JSONModel

/*
 enterpriseName = "江苏康森迪信息科技有限公司";
 noticeCreateDate = "2018-07-15";
 noticeExplain = "新疆中恒岳房地产开发有限公司：本院受理的原告奥的斯电梯（中国）有限公司与你招投标买卖合同纠纷一案，现已审理终结。依照《中华人民共和国民事诉讼法》第九十二条的规定，向你公告送达本院（2018）津0116民初80122号民事判决书。自发出本公告之日起，经过六十日即视为送达。如不服本判决，可在判决书送达之日起十五日内向本院递交上诉状及副本，上诉于天津市第二中级人民法本院（2018）津0116民初80122号民事判决书。自发出本公告之日起，经过六十日即视为送达。如不服本判决，可在判决书送达之日起十五日内向本院递交上诉状及副本，上诉于天津市第二中级人民法\351\231院。"
 noticeOriginalHref = <null>;
 noticePublisher = "天津市滨海新区人民法院（功能区)";
 noticeType = "裁判文书";
 person = "新疆中恒岳房地产开发有限公司";
 */

@property (nonatomic,copy) NSString <Optional> *enterpriseName;
@property (nonatomic,copy) NSString <Optional> *noticeCreateDate;
@property (nonatomic,copy) NSString <Optional> *noticePublishDate;
@property (nonatomic,copy) NSString <Optional> *noticeExplain;
@property (nonatomic,copy) NSString <Optional> *noticeOriginalHref;
@property (nonatomic,copy) NSString <Optional> *noticePublisher;
@property (nonatomic,copy) NSString <Optional> *noticeType;
@property (nonatomic,copy) NSString <Optional> *person;

@end
