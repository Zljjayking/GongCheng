//
//  DDCompanyClaimBenefitVC.m
//  GongChengDD
//
//  Created by xzx on 2018/12/8.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDCompanyClaimBenefitVC.h"
#import "DDAffirmEnterpriseVC.h"

#import <UShareUI/UShareUI.h>//友盟分享
#import <MessageUI/MessageUI.h>
@interface DDCompanyClaimBenefitVC ()<MFMessageComposeViewControllerDelegate>
@property (strong,nonatomic)MFMessageComposeViewController *messageController;
@end

@implementation DDCompanyClaimBenefitVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent=NO;
    self.view.backgroundColor=kColorBackGroundColor;
    self.title=@"公司认领";
    if(_isFromMyInfo == YES){
         self.navigationItem.leftBarButtonItem=[DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"我的" target:self action:@selector(leftButtonClick)];
    }else{
         self.navigationItem.leftBarButtonItem=[DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"返回" target:self action:@selector(leftButtonClick)];
    }
   
    self.navigationItem.rightBarButtonItem=[DDUtils rightbuttonItemWithImage:@"right_share" highlightedImage:@"right_share" target:self action:@selector(shareClick)];
    [self createUI];
}
//分享
-(void)shareClick{
   
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine ),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Sms)]];
    //配置上面需求的参数
    [UMSocialShareUIConfig shareInstance].shareTitleViewConfig.isShow = NO;
    [UMSocialShareUIConfig shareInstance].shareCancelControlConfig.shareCancelControlText = @"取消";
        //显示分享面板
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
            // 根据获取的platformType确定所选平台进行下一步操作
            if (platformType == UMSocialPlatformType_Sms) {
                _messageController= [[MFMessageComposeViewController alloc] init];
                UINavigationItem * navigationItem = [[[_messageController viewControllers] lastObject] navigationItem];
                [navigationItem setTitle:@"新信息"];
                UIButton * cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
                [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
                [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
                [cancelButton addTarget:self action:@selector(cancelSendSMSClick) forControlEvents:UIControlEventTouchUpInside];
                navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:cancelButton];
                
                
                // 设置短信内容
                _messageController.body = [NSString stringWithFormat:@"下载工程点点，企业证书，人员证书到期提醒，中标实时提醒，企业服务匹配 http://gcdd.koncendy.com/gcdd-download/"];
                // 设置代理
                _messageController.messageComposeDelegate = self;
                // 显示控制器
                [self presentViewController:_messageController animated:YES completion:nil];
            } else {
                UMShareWebpageObject * shareObject = [UMShareWebpageObject shareObjectWithTitle:@"通过工程点点认领我的公司，获取到精准服务" descr:@"下载工程点点，企业证书，人员证书到期提醒，中标实时提醒，企业服务匹配" thumImage:[UIImage imageNamed:@"share_logo"]];
                //设置网页地址
                shareObject.webpageUrl =[NSString stringWithFormat:@"http://gcdd.koncendy.com/gcdd-download/"];
                
                //创建分享消息对象
                UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
                //分享消息对象设置分享内容对象
                messageObject.shareObject = shareObject;
                
                //调用分享接口
                [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
                    if (error) {
                        UMSocialLogInfo(@"************分享返回的结果：%@*********",error);
                    }
                    else{
                        if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                            UMSocialShareResponse *resp = data;
                            //分享结果消息
                            UMSocialLogInfo(@"response message is %@",resp.message);
                            //第三方原始返回的数据
                            UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                            
                        }else{
                            UMSocialLogInfo(@"response data is %@",data);
                        }
                    }
                }];
            }
        }];
}
- (void)cancelSendSMSClick{
    [_messageController dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark 返回上一级
- (void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 画布局
-(void)createUI{
    UIScrollView *scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-KNavigationBarHeight-57.5)];
    scrollView.backgroundColor=kColorBackGroundColor;
    scrollView.contentSize=CGSizeMake(Screen_Width, 15+15+679*Scale+15+15);
    [self.view addSubview:scrollView];
    
    UILabel *bg1=[[UILabel alloc]initWithFrame:CGRectMake(0, 15, Screen_Width, 15)];
    bg1.backgroundColor=kColorWhite;
    [scrollView addSubview:bg1];
    
    UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 30, Screen_Width, 679*Scale)];
    imgView.backgroundColor=kColorWhite;
    imgView.image=[UIImage imageNamed:@"home_companyBenefit"];
    [scrollView addSubview:imgView];
    
    UILabel *bg2=[[UILabel alloc]initWithFrame:CGRectMake(0, 30+679*Scale, Screen_Width, 15)];
    bg2.backgroundColor=kColorWhite;
    [scrollView addSubview:bg2];
    
    UIView *bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, Screen_Height-KNavigationBarHeight-57.5, Screen_Width, 57.5)];
    bottomView.backgroundColor=kColorWhite;
    UIButton *setBtn=[[UIButton alloc]initWithFrame:CGRectMake(15, 17.5/2, Screen_Width-30, 40)];
    [setBtn setTitle:@"去认领" forState:UIControlStateNormal];
    [setBtn setBackgroundColor:KColorFindingPeopleBlue];
    setBtn.titleLabel.font=kFontSize32;
    [setBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
    setBtn.layer.cornerRadius=3;
    [setBtn addTarget:self action:@selector(goSettingClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:setBtn];
    [self.view addSubview:bottomView];
}

#pragma mark 去认领点击事件
-(void)goSettingClick{
    //如果没有认证公司,去认证公司页
    DDAffirmEnterpriseVC * vc = [[DDAffirmEnterpriseVC alloc] init];
    if(_isFromMyInfo == YES){
        vc.formMyInfoVC = YES;
    }else{
        vc.formMyInfoVC = NO;
    }
   
    vc.affirmEnterpriseSuccessBlock = ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"shoucirenlingchenggong" object:nil];
    };
    
    if (_companyClaimBenefitType == CompanyClaimBenefitTypeCompany) {
        vc.companyid = _companyid;
        vc.companyName = _companyName;
        vc.affirmEnterpriseType = AffirmEnterpriseTypeCompany;
        vc.allowChangeCompanyName = NO;
    }else{
        vc.allowChangeCompanyName = YES;//允许修改公司名
        vc.affirmEnterpriseType = AffirmEnterpriseTypeDefault;
    }
    [self.navigationController pushViewController:vc animated:YES];
}


@end
