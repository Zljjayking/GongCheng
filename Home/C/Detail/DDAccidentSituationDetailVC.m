//
//  DDAccidentSituationDetailVC.m
//  GongChengDD
//
//  Created by xzx on 2018/6/4.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDAccidentSituationDetailVC.h"
#import "DDLabelUtil.h"
#import "DDJudgePaperDetailCell.h"//cell1
#import "DDLoseCreditDetailCell.h"//cell2
#import "DDProjectDetailPictureCell.h"//cell3
#import "DDAdminPunishDetail2Cell.h"//截图cell
#import "DataLoadingView.h"//加载页面
#import "DDAccidentSituationDetailModel.h"//model
#import "DDProjectCheckOriginWebVC.h"//查看原文页面
#import "ShowFullImageView.h"//查看大图

@interface DDAccidentSituationDetailVC ()<UITableViewDelegate,UITableViewDataSource>

{
    DDAccidentSituationDetailModel *_model;
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) DataLoadingView *loadingView;

@end

@implementation DDAccidentSituationDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self editNavItem];
    [self createTableView];
    //[self createBottomBtn];
    [self createLoadView];
    [self requestData];
}

//定制导航条
-(void)editNavItem{
    self.title=@"事故情况详情";
    self.view.backgroundColor=kColorBackGroundColor;
    self.navigationItem.leftBarButtonItem=[DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"返回" target:self action:@selector(leftButtonClick)];
}

//返回上一页
- (void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

//创建查看原文按钮
-(void)createBottomBtn{
    UIView *bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, Screen_Height-KNavigationBarHeight-49, Screen_Width, 49)];
    bottomView.backgroundColor=kColorWhite;
    [self.view addSubview:bottomView];
    
    UIButton *checkPaperBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 49)];
    [bottomView addSubview:checkPaperBtn];
    
    [checkPaperBtn setTitle:@"查看原文>>" forState:UIControlStateNormal];
    checkPaperBtn.titleLabel.font=kFontSize30;
    [checkPaperBtn setTitleColor:kColorBlue forState:UIControlStateNormal];
    [checkPaperBtn addTarget:self action:@selector(checkPaperClick) forControlEvents:UIControlEventTouchUpInside];
}

//查看原文
-(void)checkPaperClick{
    DDProjectCheckOriginWebVC *projectCheckOriginWebVC=[[DDProjectCheckOriginWebVC alloc]init];
    //projectCheckOriginWebVC.hostUrl=_model.hostUrl;
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
    [params setValue:self.accident_id forKey:@"accidentId"];
    
    [[DDHttpManager sharedInstance]sendGetRequest:KHttpRequest_accidentDetailByID params:params success:^(NSURLSessionDataTask *operation, id responseObject){
        NSLog(@"**********事故情况详情数据***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {
            [_loadingView hiddenLoadingView];
            _model=[[DDAccidentSituationDetailModel alloc]initWithDictionary:responseObject[KData] error:nil];
        }
        else{
            
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
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-KNavigationBarHeight) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.backgroundColor=kColorBackGroundColor;
    _tableView.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.separatorColor=KColorTableSeparator;
    _tableView.estimatedRowHeight=44;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, KTableViewFooterViewHeight)];
}

#pragma mark tableView代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //content  内容判断是否有截图，没有值就有截图
    if (![DDUtils isEmptyString:_model.content]) {//决策文书号有值，是文本形式
        if (![DDUtils isEmptyString:_model.enclosure]) {//附件名有值，是文本加附件形式
            return 5;
        }
        else{//附件名为空，是纯文本形式
            return 5;
        }
    }
    else{//决策文书号为空，是截图类型
        if (![DDUtils isEmptyString:_model.enclosure]) {//附件名有值，是截图加附件形式
            return 5;
        }
        else{//附件名为空，是纯截图形式
            return 5;
        }
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        static NSString * cellID = @"DDJudgePaperDetailCell";
        DDJudgePaperDetailCell * cell = (DDJudgePaperDetailCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
        }
        
        cell.distanceToTop.constant=-3;
        cell.tipLab.hidden=YES;
        cell.distanceToBottom.constant=20;
        cell.textView.textColor=KColorCompanyTitleBalck;
        cell.textView.font=kFontSize30Bold;
        cell.textView.text=_model.accident_title;
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    
    
    //content  决策文书号判断是否是截图，没有值就是截图
    if (![DDUtils isEmptyString:_model.content]) {//决策文书号有值，是文本形式
        if (![DDUtils isEmptyString:_model.enclosure]) {//附件名有值，是文本加附件形式
            if (indexPath.row==4) {
                static NSString * cellID = @"DDJudgePaperDetailCell";
                DDJudgePaperDetailCell * cell = (DDJudgePaperDetailCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                if (cell == nil) {
                    cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
                }
                
                //NSString *titleStr=[NSString stringWithFormat:@"<font color='#222222'>%@</font>",_model.content];
                NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithData:[_model.content dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
                
                cell.distanceToTop.constant=20;
                cell.tipLab.hidden=NO;
                cell.distanceToBottom.constant=0;
                cell.textView.attributedText = attributeStr;
                cell.textView.font=kFontSize30;
                
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                return cell;
            }
            else{
                static NSString * cellID = @"DDLoseCreditDetailCell";
                DDLoseCreditDetailCell * cell = (DDLoseCreditDetailCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                if (cell == nil) {
                    cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
                }
                
                if (indexPath.row==1) {
                    cell.titleLab.text=@"企业名称";
                    cell.detailLab.text=_model.enterprise_name;
                }
                else if (indexPath.row==2) {
                    cell.titleLab.text=@"负责人";
                    cell.detailLab.text=_model.staff_name;
                }
                else if (indexPath.row==3){
                    cell.titleLab.text=@"发布时间";
                    cell.detailLab.text=_model.accident_issue_time;
                }
                
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                return cell;
            }
        }
        else{//附件名为空，是纯文本形式
            if (indexPath.row==4) {
                static NSString * cellID = @"DDJudgePaperDetailCell";
                DDJudgePaperDetailCell * cell = (DDJudgePaperDetailCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                if (cell == nil) {
                    cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
                }
                
                //NSString *titleStr=[NSString stringWithFormat:@"<font color='#222222'>%@</font>",_model.content];
                NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithData:[_model.content dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
                
                cell.distanceToTop.constant=20;
                cell.tipLab.hidden=NO;
                cell.distanceToBottom.constant=0;
                cell.textView.attributedText = attributeStr;
                cell.textView.font=kFontSize30;
                
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                return cell;
            }
            else{
                static NSString * cellID = @"DDLoseCreditDetailCell";
                DDLoseCreditDetailCell * cell = (DDLoseCreditDetailCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                if (cell == nil) {
                    cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
                }
                
                if (indexPath.row==1) {
                    cell.titleLab.text=@"企业名称";
                    cell.detailLab.text=_model.enterprise_name;
                }
                else if (indexPath.row==2) {
                    cell.titleLab.text=@"负责人";
                    cell.detailLab.text=_model.staff_name;
                }
                else if (indexPath.row==3){
                    cell.titleLab.text=@"发布时间";
                    cell.detailLab.text=_model.accident_issue_time;
                }
                
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                return cell;
            }
        }
    }
    else{//决策文书号为空，是截图类型
        if (![DDUtils isEmptyString:_model.enclosure]) {//附件名有值，是截图加附件形式
            if (indexPath.row==4) {
                static NSString * cellID = @"DDAdminPunishDetail2Cell";
                DDAdminPunishDetail2Cell * cell = (DDAdminPunishDetail2Cell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                if (cell == nil) {
                    cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
                }
                
                [cell.pictureImg sd_setImageWithURL:[NSURL URLWithString:_model.accident_original_img] placeholderImage:[UIImage imageNamed:@"home_detail_scanPic"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if (image) {
                        cell.pictureImg.image = image;
                    }
                }];
                
                UIButton *btn=[[UIButton alloc]initWithFrame:cell.pictureImg.frame];
                [btn addTarget:self action:@selector(enlargePictureClick) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:btn];
                
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                return cell;
            }
            else{
                static NSString * cellID = @"DDLoseCreditDetailCell";
                DDLoseCreditDetailCell * cell = (DDLoseCreditDetailCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                if (cell == nil) {
                    cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
                }
                
                if (indexPath.row==1) {
                    cell.titleLab.text=@"企业名称";
                    cell.detailLab.text=_model.enterprise_name;
                }
                else if (indexPath.row==2) {
                    cell.titleLab.text=@"项目经理";
                    cell.detailLab.text=_model.staff_name;
                }
                else if (indexPath.row==3){
                    cell.titleLab.text=@"发布时间";
                    cell.detailLab.text=_model.accident_issue_time;
                }
                
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                return cell;
            }
        }
        else{//附件名为空，是纯截图形式
            if (indexPath.row==4) {
                static NSString * cellID = @"DDAdminPunishDetail2Cell";
                DDAdminPunishDetail2Cell * cell = (DDAdminPunishDetail2Cell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                if (cell == nil) {
                    cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
                }
                
                [cell.pictureImg sd_setImageWithURL:[NSURL URLWithString:_model.accident_original_img] placeholderImage:[UIImage imageNamed:@"home_detail_scanPic"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if (image) {
                        cell.pictureImg.image = image;
                    }
                }];
                
                UIButton *btn=[[UIButton alloc]initWithFrame:cell.pictureImg.frame];
                [btn addTarget:self action:@selector(enlargePictureClick) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:btn];
                
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                return cell;
            }
            else{
                static NSString * cellID = @"DDLoseCreditDetailCell";
                DDLoseCreditDetailCell * cell = (DDLoseCreditDetailCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                if (cell == nil) {
                    cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
                }
                
                if (indexPath.row==1) {
                    cell.titleLab.text=@"企业名称";
                    cell.detailLab.text=_model.enterprise_name;
                }
                else if (indexPath.row==2) {
                    cell.titleLab.text=@"项目经理";
                    cell.detailLab.text=_model.staff_name;
                }
                else if (indexPath.row==3){
                    cell.titleLab.text=@"发布时间";
                    cell.detailLab.text=_model.accident_issue_time;
                }
                
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                return cell;
            }
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return UITableViewAutomaticDimension;
    }
    else{
        if (![DDUtils isEmptyString:_model.content]) {//决策文书号有值，是文本形式
            if (![DDUtils isEmptyString:_model.enclosure]) {//附件名有值，是文本加附件形式
                return UITableViewAutomaticDimension;
            }
            else{//附件名为空，是纯文本形式
                return UITableViewAutomaticDimension;
            }
        }
        else{//决策文书号为空，是截图类型
            if (![DDUtils isEmptyString:_model.enclosure]) {//附件名有值，是截图加附件形式
                if (indexPath.row==4) {
                    return 315;
                }
                else{
                    return UITableViewAutomaticDimension;
                }
            }
            else{//附件名为空，是纯截图形式
                if (indexPath.row==4) {
                    return 315;
                }
                else{
                    return UITableViewAutomaticDimension;
                }
            }
        }
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (![DDUtils isEmptyString:_model.content]) {//决策文书号有值，是文本形式
        if (![DDUtils isEmptyString:_model.enclosure]) {//附件名有值，是文本加附件形式
            UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 50)];
            bgView.backgroundColor=kColorWhite;
            
            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(12, 17.5, 48, 15)];
            label.text=@"附件：";
            label.textColor=kColorBlue;
            label.font=kFontSize30;
            [bgView addSubview:label];
            
            CGRect btnFrame = [_model.enclosure boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize30} context:nil];
            UIButton *linkBtn;
            if (btnFrame.size.width>Screen_Width-24-48) {
                linkBtn=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label.frame), 17.5, Screen_Width-24-48, 15)];
            }
            else{
                linkBtn=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label.frame), 17.5, btnFrame.size.width, 15)];
            }
            [linkBtn setTitle:_model.enclosure forState:UIControlStateNormal];
            [linkBtn setTitleColor:kColorBlue forState:UIControlStateNormal];
            linkBtn.titleLabel.font=kFontSize30;
            [linkBtn addTarget:self action:@selector(fileClick) forControlEvents:UIControlEventTouchUpInside];
            [bgView addSubview:linkBtn];
            
            return bgView;
        }
        else{//附件名为空，是纯文本形式
            return nil;
        }
    }
    else{//决策文书号为空，是截图类型
        if (![DDUtils isEmptyString:_model.enclosure]) {//附件名有值，是截图加附件形式
            UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 50)];
            bgView.backgroundColor=kColorWhite;
            
            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(12, 17.5, 48, 15)];
            label.text=@"附件：";
            label.textColor=kColorBlue;
            label.font=kFontSize30;
            [bgView addSubview:label];
            
            CGRect btnFrame = [_model.enclosure boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize30} context:nil];
            UIButton *linkBtn;
            if (btnFrame.size.width>Screen_Width-24-48) {
                linkBtn=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label.frame), 17.5, Screen_Width-24-48, 15)];
            }
            else{
                linkBtn=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label.frame), 17.5, btnFrame.size.width, 15)];
            }
            [linkBtn setTitle:_model.enclosure forState:UIControlStateNormal];
            [linkBtn setTitleColor:kColorBlue forState:UIControlStateNormal];
            linkBtn.titleLabel.font=kFontSize30;
            [linkBtn addTarget:self action:@selector(fileClick) forControlEvents:UIControlEventTouchUpInside];
            [bgView addSubview:linkBtn];
            
            return bgView;
        }
        else{//附件名为空，是纯截图形式
            return nil;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    //book_num  决策文书号判断是否是截图，没有值就是截图
    if (![DDUtils isEmptyString:_model.content]) {//决策文书号有值，是文本形式
        if (![DDUtils isEmptyString:_model.enclosure]) {//附件名有值，是文本加附件形式
            return 50;
        }
        else{//附件名为空，是纯文本形式
            return CGFLOAT_MIN;
        }
    }
    else{//决策文书号为空，是截图类型
        if (![DDUtils isEmptyString:_model.enclosure]) {//附件名有值，是截图加附件形式
            return 50;
        }
        else{//附件名为空，是纯截图形式
            return CGFLOAT_MIN;
        }
    }
}

#pragma mark 点击加载附件
-(void)fileClick{
    DDProjectCheckOriginWebVC *webView=[[DDProjectCheckOriginWebVC alloc]init];
    webView.hostUrl=_model.enclosureUrl;
    [self.navigationController pushViewController:webView animated:YES];
}

#pragma mark 点击放大
-(void)enlargePictureClick{
    NSMutableArray *array=[[NSMutableArray alloc]init];
    if (![DDUtils isEmptyString:_model.accident_original_img]) {
        [array addObject:_model.accident_original_img];
        ShowFullImageView *showFullImage=[[ShowFullImageView alloc]initWithImageUrlArray:array];
        [showFullImage show];
    }
}


@end
