//
//  DDPeopleDetailVC.h
//  GongChengDD
//
//  Created by xzx on 2018/5/25.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDSearchPeopleListModel.h"
#import "DDSearchBuilderAndManagerListModel.h"
@interface DDPeopleDetailVC : UIViewController

@property (nonatomic,strong) NSString *isFromCompanyDetail;//1表示从企业详情跳转过来的
@property (nonatomic,strong) NSString *isFromMyCerti;//1表示从我的证书跳转过来的
@property (nonatomic,strong) NSString *staffInfoId;//人员id
@property (nonatomic,strong) DDSearchBuilderAndManagerListModel *peopleModel;
@end
