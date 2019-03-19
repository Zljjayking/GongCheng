//
//  DDIndustryDynamicListModel.h
//  GongChengDD
//
//  Created by xzx on 2018/6/8.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface DDIndustryDynamicListModel : JSONModel

/*
 attr_img = "1633720835474432";
 dept_source = "南京市城乡建设委员会";
 doc_id = 1342809663734272;
 publish_date_source = "2018-02-28 17:31:39";
 reading_quantity = 0
 share_title = "分享：建筑工程（WXXQ201802001-W01）";
 title = "建筑工程（WXXQ201802001-W01）";
 title_type = 1;
 url = "http://xzfw.wuxi.gov.cn/doc/2018/02/09/1740292.shtml";
 */

@property (nonatomic,copy) NSString <Optional> *attr_img;
@property (nonatomic,copy) NSString <Optional> *dept_source;
@property (nonatomic,copy) NSString <Optional> *doc_id;
@property (nonatomic,copy) NSString <Optional> *publish_date_source;
@property (nonatomic,copy) NSString <Optional> *reading_quantity;
@property (nonatomic,copy) NSString <Optional> *share_title;
@property (nonatomic,copy) NSString <Optional> *title;
@property (nonatomic,copy) NSString <Optional> *title_type;
@property (nonatomic,copy) NSString <Optional> *isThumbUp;
@property (nonatomic,copy) NSString <Optional> *count;

@end
