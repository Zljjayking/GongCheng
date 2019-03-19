//
//  DDProjectDetailVC.m
//  GongChengDD
//
//  Created by xzx on 2018/5/23.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDProjectDetailVC.h"
#import "DDLabelUtil.h"
#import "DDProjectDetailInfoCell.h"//cell1
#import "DDNewFindingWinBiddingProjectCell.h"

#import "DDProjectDetailPictureCell.h"//cell2
#import "DataLoadingView.h"//加载页面
#import "DDProjectDetailModel.h"//model
#import "DDProjectCheckOriginWebVC.h"//查看原文页面

#import "ShowFullImageView.h"//查看大图
#import "DDServiceWebViewVC.h"
@interface DDProjectDetailVC ()<UITableViewDelegate,UITableViewDataSource>

{
    DDProjectDetailModel *_model;
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) DataLoadingView *loadingView;

@end

@implementation DDProjectDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=kColorWhite;
    self.navigationItem.leftBarButtonItem=[DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"返回" target:self action:@selector(leftButtonClick)];
    [self createTableView];
    if (_isHiddenBottom == NO) {
        [self createBottomBtn];
    }else{
        [_tableView setFrameHeight:Screen_Height-KNavigationBarHeight-KHomeIndicatorHeight];
    }
    [self createLoadView];
    [self requestData];
}


//返回上一页
- (void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

//收藏
-(void)shareClick{
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [params setValue:self.winCaseId forKey:@"collectId"];
    [params setValue:@"1" forKey:@"collectType"];//中标
    
    MBProgressHUD * hud = [DDUtils showHUDCustom:@""];
    [[DDHttpManager sharedInstance]sendPostRequest:KHttpRequest_saveMyCollection params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"**********项目详情的收藏***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {
            hud.mode = MBProgressHUDModeCustomView;
            hud.customView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cer_success"]];
            hud.labelText=@"已收藏";
            hud.completionBlock= ^(){
                self.navigationItem.rightBarButtonItem=[DDUtils rightbuttonItemWithTitle:@"已收藏" target:self action:nil];
                
                //发个通知,
                [[NSNotificationCenter defaultCenter]postNotificationName:KCollectWinBiddOrCancel object:nil];
            };
        }else if (response.code == 150){//150表示PC端已经收藏过了
            hud.labelText = @"你已经收藏过该项目";
            hud.completionBlock= ^(){
                self.navigationItem.rightBarButtonItem=[DDUtils rightbuttonItemWithTitle:@"已收藏" target:self action:nil];
                
                //发个通知,
                [[NSNotificationCenter defaultCenter]postNotificationName:KCollectWinBiddOrCancel object:nil];
            };
        }
        else{
            [DDUtils showToastWithMessage:response.message];
        }
        
        [hud hide:YES afterDelay:KHudShowTimeSecound];
    } failure:^(NSURLSessionDataTask *operation, id responseObject) {
        hud.labelText = kRequestFailed;
        [hud hide:YES afterDelay:KHudShowTimeSecound];
    }];
}

//获取当前的时间
-(NSString*)getCurrentTimes{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    //设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    //现在时间,你可以输出来看下是什么格式
    NSDate *datenow = [NSDate date];
    
    //将nsdate按formatter格式转成nsstring
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    return currentTimeString;
}

//创建查看原文按钮
-(void)createBottomBtn{
//    UIView *bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, Screen_Height-KNavigationBarHeight-49, Screen_Width, 49)];
//    bottomView.backgroundColor=kColorWhite;
//    [self.view addSubview:bottomView];
//
//    UIButton *checkPaperBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 49)];
//    [bottomView addSubview:checkPaperBtn];
//
//    [checkPaperBtn setTitle:@"查看原文>>" forState:UIControlStateNormal];
//    checkPaperBtn.titleLabel.font=kFontSize30;
//    [checkPaperBtn setTitleColor:kColorBlue forState:UIControlStateNormal];
//    [checkPaperBtn addTarget:self action:@selector(checkPaperClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *bottomBtn1=[[UIButton alloc]initWithFrame:CGRectMake(0, Screen_Height-KNavigationBarHeight-KHomeIndicatorHeight-49, Screen_Width/3, 49)];
    bottomBtn1.backgroundColor=kColorWhite;
    UIImageView *imgView1=[[UIImageView alloc]initWithFrame:CGRectMake((Screen_Width/3-20)/2, 5, WidthByiPhone6(17), WidthByiPhone6(20))];
    imgView1.image=[UIImage imageNamed:@"finding_project_contract"];
    [bottomBtn1 addSubview:imgView1];
    UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imgView1.frame)+7, Screen_Width/3, 15)];
    label1.text=@"履约保证险";
    label1.textColor=KColorBottomBtnGrey;
    label1.font=KFontSize22;
    label1.textAlignment=NSTextAlignmentCenter;
    [bottomBtn1 addSubview:label1];
    [bottomBtn1 addTarget:self action:@selector(contractClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bottomBtn1];
    
    UIButton *bottomBtn2=[[UIButton alloc]initWithFrame:CGRectMake(Screen_Width/3, Screen_Height-KNavigationBarHeight-KHomeIndicatorHeight-49, Screen_Width/3, 49)];
    bottomBtn2.backgroundColor=kColorWhite;
    UIImageView *imgView2=[[UIImageView alloc]initWithFrame:CGRectMake((Screen_Width/3-20)/2, 5, WidthByiPhone6(17), WidthByiPhone6(20))];
    imgView2.image=[UIImage imageNamed:@"finding_project_quality"];
    [bottomBtn2 addSubview:imgView2];
    UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imgView2.frame)+7, Screen_Width/3, 15)];
    label2.text=@"质量保证险";
    label2.textColor=KColorBottomBtnGrey;
    label2.font=KFontSize22;
    label2.textAlignment=NSTextAlignmentCenter;
    [bottomBtn2 addSubview:label2];
    [bottomBtn2 addTarget:self action:@selector(qualityClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bottomBtn2];
    
    UIButton *bottomBtn3=[[UIButton alloc]initWithFrame:CGRectMake(Screen_Width/3*2, Screen_Height-KNavigationBarHeight-KHomeIndicatorHeight-49, Screen_Width/3, 49)];
    bottomBtn3.backgroundColor=kColorWhite;
    UIImageView *imgView3=[[UIImageView alloc]initWithFrame:CGRectMake((Screen_Width/3-20)/2, 5, WidthByiPhone6(17), WidthByiPhone6(20))];
    imgView3.image=[UIImage imageNamed:@"finding_project_guarantee"];
    [bottomBtn3 addSubview:imgView3];
    UILabel *label3=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imgView3.frame)+7, Screen_Width/3, 15)];
    label3.text=@"担保公司";
    label3.textColor=KColorBottomBtnGrey;
    label3.font=KFontSize22;
    label3.textAlignment=NSTextAlignmentCenter;
    [bottomBtn3 addSubview:label3];
    [bottomBtn3 addTarget:self action:@selector(guaranteeClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bottomBtn3];
}

//查看原文
-(void)checkPaperClick{
    DDProjectCheckOriginWebVC *projectCheckOriginWebVC=[[DDProjectCheckOriginWebVC alloc]init];
    projectCheckOriginWebVC.hostUrl=_model.hostUrl;
    [self.navigationController pushViewController:projectCheckOriginWebVC animated:YES];
}

#pragma mark 创建加载视图
-(void)createLoadView{
    __weak __typeof(self) weakSelf=self;
    
    _loadingView = [[DataLoadingView alloc] initWithController:self];
    _loadingView.loadingTitle = KLoading;
    _loadingView.failureTitle = KLoadingFailure;
    _loadingView.reloadHandle = ^(void){
        [weakSelf requestData];
    };
    [_loadingView showLoadingView];
}

#pragma mark 请求数据
-(void)requestData{
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
    [params setValue:self.winCaseId forKey:@"winCaseId"];
    
    [[DDHttpManager sharedInstance]sendGetRequest:KHttpRequest_winBiddingDetailByID params:params success:^(NSURLSessionDataTask *operation, id responseObject){
        NSLog(@"**********项目详情数据***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {
            [_loadingView hiddenLoadingView];
            _model=[[DDProjectDetailModel alloc]initWithDictionary:responseObject[KData] error:nil];
            if (![DDUtils isEmptyString:_model.is_collect]) {
                if ([_model.is_collect isEqualToString:@"0"]) {
                    self.navigationItem.rightBarButtonItem=[DDUtils rightbuttonItemWithTitle:@"收藏" target:self action:@selector(shareClick)];
                }
                else{
                    self.navigationItem.rightBarButtonItem=[DDUtils rightbuttonItemWithTitle:@"已收藏" target:self action:nil];
                }
            }else{
                self.navigationItem.rightBarButtonItem=[DDUtils rightbuttonItemWithTitle:@"收藏" target:self action:@selector(shareClick)];
            }
        }
        else{
            [DDUtils showToastWithMessage:response.message];
            [_loadingView failureLoadingView];
        }

        [_tableView reloadData];
        
    }  failure:^(NSURLSessionDataTask *operation, id responseObject)  {
        [DDUtils showToastWithMessage:kRequestFailed];
        [_loadingView failureLoadingView];
    }];
}

//创建tableView
-(void)createTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, -1, Screen_Width, Screen_Height-KNavigationBarHeight-KHomeIndicatorHeight-49) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.backgroundColor=kColorBackGroundColor;
//    _tableView.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.showsVerticalScrollIndicator=NO;
//    _tableView.separatorColor=KColorTableSeparator;
    
    [_tableView registerClass:[DDNewFindingWinBiddingProjectCell class] forCellReuseIdentifier:@"DDNewFindingWinBiddingProjectCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"DDProjectDetailPictureCell" bundle:nil] forCellReuseIdentifier:@"DDProjectDetailPictureCell"];
}

#pragma mark tableView代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        DDNewFindingWinBiddingProjectCell *cell=[tableView dequeueReusableCellWithIdentifier:@"DDNewFindingWinBiddingProjectCell" forIndexPath:indexPath];
       
        cell.titleLab.font = KFontSize38;
        if (![DDUtils isEmptyString:_model.title]) {
            if (![DDUtils isEmptyString:_model.projectTypeName]) {
                cell.titleLab.text=[NSString stringWithFormat:@"[%@]%@",_model.projectTypeName,_model.title];
            }else{
                cell.titleLab.text=[NSString stringWithFormat:@"%@",_model.title];
            }
        }else{
            cell.titleLab.text = @"";
        }
        cell.winLab.text = @"项目经理:";
        cell.winBiddingLab.textColor=KColorBlackSubTitle;
        if (![DDUtils isEmptyString:_model.project_manager]) {
            cell.winBiddingLab.text=_model.project_manager;
        }
        else{
            cell.winBiddingLab.text=@"-";
        }
        cell.priceLab2.textColor = KColorBlackSubTitle;
        [cell.priceLab2 mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.winBiddingLab).offset(WidthByiPhone6(-5));
        }];
        if (![DDUtils isEmptyString:_model.money_type]) {
            if ([_model.money_type integerValue] == 0) {
                
                if (![DDUtils isEmptyString:_model.amount]) {
                    if([_model.amount isEqualToString:@"0.00"]){
                        cell.priceLab2.text=@"-";
                    }
                    else if([_model.amount isEqualToString:@"0"]){
                        cell.priceLab2.text=@"-";
                    }
                    else{
                        cell.priceLab2.text=[NSString stringWithFormat:@"%@万",[self handleAmount:_model.amount]];
                    }
                }
                else{
                    cell.priceLab2.text=@"-";
                }
            }else{
                cell.priceLab2.text=_model.win_bid_text;
            }
        }else{
            cell.priceLab2.text=@"-";
        }
        cell.timeLab2.textColor = KColorBlackSubTitle;
        if (![DDUtils isEmptyString:_model.publish_date]) {
            cell.timeLab2.text= _model.publish_date;
        }
        else{
            cell.timeLab2.text=@"-";
        }
        return cell;
    }
    else{
        DDProjectDetailPictureCell *cell=[tableView dequeueReusableCellWithIdentifier:@"DDProjectDetailPictureCell" forIndexPath:indexPath];

        [cell loadDataWithContent:@"" andPic:@""];

        [cell.pictureImg sd_setImageWithURL:[NSURL URLWithString:_model.image] placeholderImage:[UIImage imageNamed:@"home_detail_scanPic"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                cell.pictureImg.image = image;
            }
        }];

        UIButton *btn=[[UIButton alloc]initWithFrame:cell.pictureImg.frame];
        [btn addTarget:self action:@selector(enlargePictureClick) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:btn];

        //UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(enlargePictureClick)];
        //[cell.pictureImg addGestureRecognizer:tap];

        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
        
        return nil;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        NSString *nameStr = _model.title;
        if (![DDUtils isEmptyString:_model.projectTypeName]) {
            nameStr=[NSString stringWithFormat:@"[%@]%@",_model.projectTypeName,_model.title];
        }
        CGFloat cellHeight = 0.0;
        if(![DDUtils isEmptyString:[NSString stringWithFormat:@"%@",nameStr]]){
            CGSize labelSize = [[NSString stringWithFormat:@"%@",nameStr] boundingRectWithSize:CGSizeMake(Screen_Width-WidthByiPhone6(24), 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:KFontSize38} context:nil].size;
            cellHeight = labelSize.height;
        }else{
            cellHeight = WidthByiPhone6(20);
        }
        
        if (![DDUtils isEmptyString:_model.money_type]) {
            if ([_model.money_type integerValue] != 0) {
                NSString *timeStr = _model.win_bid_text;
                CGSize labelSize = [[NSString stringWithFormat:@"%@",timeStr] boundingRectWithSize:CGSizeMake(Screen_Width-WidthByiPhone6(73), 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:kFontSize28} context:nil].size;
                return labelSize.height+cellHeight + WidthByiPhone6(115);
            }else{
                return cellHeight+WidthByiPhone6(135);
            }
        }else{
            return cellHeight+WidthByiPhone6(135);
        }
        
    }
    else{
        return [DDLabelUtil getSpaceLabelHeightWithString:@" " font:KFontSize22 width:(Screen_Width-24)]+335;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 15;
}

#pragma mark 点击放大
-(void)enlargePictureClick{
    NSMutableArray *array=[[NSMutableArray alloc]init];
    if (![DDUtils isEmptyString:_model.image]) {
        [array addObject:_model.image];
        ShowFullImageView *showFullImage=[[ShowFullImageView alloc]initWithImageUrlArray:array];
        [showFullImage show];
    }
}

#pragma mark 去除小数点后多余的0
- (NSString*)removeFloatAllZeroByString:(NSString *)testNumber{
    NSString * outNumber = [NSString stringWithFormat:@"%@",@(testNumber.doubleValue)];
    return outNumber;
}

#pragma mark 履约保证险点击
-(void)contractClick{
    DDServiceWebViewVC * checkVC = [DDServiceWebViewVC new];
    checkVC.hostUrl = @"http://gcdd.koncendy.com/apphs/insuranceAndCompanyTrading/#/insuranceList/chooseInsurance?id=11";
    checkVC.serviceWebViewType = DDServiceWebViewTypeOther;
    [self.navigationController pushViewController:checkVC animated:YES];
   
}

#pragma mark 质量保证险点击
-(void)qualityClick{
    DDServiceWebViewVC * checkVC = [DDServiceWebViewVC new];
    checkVC.hostUrl = @"http://gcdd.koncendy.com/apphs/insuranceAndCompanyTrading/#/insuranceList/chooseInsurance?id=13";
    checkVC.serviceWebViewType = DDServiceWebViewTypeOther;
    [self.navigationController pushViewController:checkVC animated:YES];
}

#pragma mark 担保公司点击
-(void)guaranteeClick{
    DDServiceWebViewVC * checkVC = [DDServiceWebViewVC new];
    checkVC.hostUrl = @"http://gcdd.koncendy.com/apphs/guarantee";
    [self.navigationController pushViewController:checkVC animated:YES];
}

-(NSString *)handleAmount:(NSString *)amount{
    //需要参与运算的两个数
    NSDecimalNumber *num = [NSDecimalNumber decimalNumberWithString:amount];
    NSDecimalNumber *w = [NSDecimalNumber decimalNumberWithString:@"10000"];
    
    //运算结果处理：小数精确到后2位，其余位无条件舍弃
    NSDecimalNumberHandler *handler = [NSDecimalNumberHandler
                                       decimalNumberHandlerWithRoundingMode:NSRoundDown//要使用的舍入模式
                                       scale:8            //结果保留几位小数
                                       raiseOnExactness:NO //发生精确错误时是否抛出异常，一般为NO
                                       raiseOnOverflow:NO  //发生溢出错误时是否抛出异常，一般为NO
                                       raiseOnUnderflow:NO //发生不足错误时是否抛出异常，一般为NO
                                       raiseOnDivideByZero:YES];//被0除时是否抛出异常，一般为YES
    
    //将两个数进行除法运算，并对结果加以处理(handler)
    num = [num decimalNumberByDividingBy:w withBehavior:handler];
    NSString *ret = [NSString stringWithFormat:@"%@", num];
    return ret;
}


@end
