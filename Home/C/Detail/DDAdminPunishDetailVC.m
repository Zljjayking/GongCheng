//
//  DDAdminPunishDetailVC.m
//  GongChengDD
//
//  Created by xzx on 2018/6/4.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDAdminPunishDetailVC.h"
#import "DDLabelUtil.h"
#import "DDAdminPunishDetail1Cell.h"//标题cell
#import "DDAdminPunishDetail2Cell.h"//截图cell
#import "DDLoseCreditDetailCell.h"//其余文本cell
#import "DataLoadingView.h"//加载页面
#import "DDAdminPunishDetailModel.h"//model
#import "DDProjectCheckOriginWebVC.h"//查看原文页面
#import "ShowFullImageView.h"//查看大图
#import "UIView+WhenTappedBlocks.h"

@interface DDAdminPunishDetailVC ()<UITableViewDelegate,UITableViewDataSource>

{
    DDAdminPunishDetailModel *_model;
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) DataLoadingView *loadingView;

@end

@implementation DDAdminPunishDetailVC

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
    if ([self.punishType isEqualToString:@"1"]) {
        self.title=@"环保处罚详情";
    }
    else if ([self.punishType isEqualToString:@"2"]) {
        self.title=@"工地处罚详情";
    }
    else{
        self.title=@"行政处罚详情";
    }
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
    [params setValue:self.punish_id forKey:@"punishId"];
    
    [[DDHttpManager sharedInstance]sendGetRequest:KHttpRequest_adminPunishDetailByID params:params success:^(NSURLSessionDataTask *operation, id responseObject){
        NSLog(@"**********行政处罚详情数据***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {
            [_loadingView hiddenLoadingView];
            _model=[[DDAdminPunishDetailModel alloc]initWithDictionary:responseObject[KData] error:nil];
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
    //book_num  决策文书号判断是否是截图，没有值就是截图
    if ([DDUtils isEmptyString:_model.book_num] || [_model.book_num isEqualToString:@"-"]) {//决策文书号有值，是文本形式
        if ([DDUtils isEmptyString:_model.punish_original_href] || [DDUtils isEmptyString:_model.punish_original_img]) {//附件名有值，是文本加附件形式
            return 4;
        }
        else{//是截图类型
            return 5;
        }
    }
    else{//是纯文本形式
        
        return 11;
    
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        //单位名称
        static NSString * cellID = @"DDAdminPunishDetail1Cell";
        DDAdminPunishDetail1Cell * cell = (DDAdminPunishDetail1Cell*)[tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
        }
        
        cell.titleLab.text=_model.punish_name;
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }

    
    
    
    //book_num  决策文书号判断是否是截图，没有值就是截图
    if ([DDUtils isEmptyString:_model.book_num] || [_model.book_num isEqualToString:@"-"]) {//决策文书号有值，是文本形式
        if ([DDUtils isEmptyString:_model.punish_original_href]) {//无值 都隐藏
            static NSString * cellID = @"DDLoseCreditDetailCell";
            DDLoseCreditDetailCell * cell = (DDLoseCreditDetailCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
            }
            
            if (indexPath.row==1) {
                cell.titleLab.text=@"被处罚单位";
                if ([DDUtils isEmptyString:_model.enterprise_name]) {
                    cell.detailLab.text=@"-";
                }
                else{
                    cell.detailLab.text=_model.enterprise_name;
                }
            }
            else if (indexPath.row==2){
                cell.titleLab.text=@"负责人";
                if ([DDUtils isEmptyString:_model.staff_name]) {
                    cell.detailLab.text=@"-";
                }
                else{
                    cell.detailLab.text=_model.staff_name;
                }
            }
            else if (indexPath.row==3){
                cell.titleLab.text=@"处罚决定日期";
                cell.detailLab.text=_model.punish_time;
            }
            
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
        else{//显示图片
            static NSString * cellID = @"DDLoseCreditDetailCell";
            DDLoseCreditDetailCell * cell = (DDLoseCreditDetailCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
            }
            
            if (indexPath.row==1) {
                cell.titleLab.text=@"被处罚单位";
                if ([DDUtils isEmptyString:_model.enterprise_name]) {
                    cell.detailLab.text=@"-";
                }
                else{
                    cell.detailLab.text=_model.enterprise_name;
                }
            }
            else if (indexPath.row==2){
                cell.titleLab.text=@"负责人";
                if ([DDUtils isEmptyString:_model.staff_name]) {
                    cell.detailLab.text=@"-";
                }
                else{
                    cell.detailLab.text=_model.staff_name;
                }
            }
            else if (indexPath.row==3){
                cell.titleLab.text=@"处罚决定日期";
                cell.detailLab.text=_model.punish_time;
            }
            else if (indexPath.row==4){
                static NSString * cellID = @"DDAdminPunishDetail2Cell";
                DDAdminPunishDetail2Cell * cell = (DDAdminPunishDetail2Cell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                if (cell == nil) {
                    cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
                }
                
                [cell.pictureImg sd_setImageWithURL:[NSURL URLWithString:_model.punish_original_img] placeholderImage:[UIImage imageNamed:@"home_detail_scanPic"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
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
            
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    else{//决策文书号为空，是截图类型
        static NSString * cellID = @"DDLoseCreditDetailCell";
        DDLoseCreditDetailCell * cell = (DDLoseCreditDetailCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
        }
        
        if (indexPath.row==1) {
            cell.titleLab.text=@"决定文书号";
            cell.detailLab.text=_model.book_num;
        }
        else if (indexPath.row==2) {
            cell.titleLab.text=@"被处罚单位";
            if ([DDUtils isEmptyString:_model.enterprise_name]) {
                cell.detailLab.text=@"-";
            }
            else{
                cell.detailLab.text=_model.enterprise_name;
            }
        }
        else if (indexPath.row==3){
            cell.titleLab.text=@"负责人";
            if ([DDUtils isEmptyString:_model.staff_name]) {
                cell.detailLab.text=@"-";
            }
            else{
                cell.detailLab.text=_model.staff_name;
            }
        }
        else if (indexPath.row==4){
            cell.titleLab.text=@"处罚机关";
            cell.detailLab.text=_model.bulletin_department;
        }
        else if (indexPath.row==5){
            cell.titleLab.text=@"处罚决定日期";
            cell.detailLab.text=_model.punish_time;
        }
        else if (indexPath.row==6){
            cell.titleLab.text=@"处罚类别";
            cell.detailLab.text=_model.punish_type;
        }
        else if (indexPath.row==7){
            cell.titleLab.text=@"处罚结果";
            cell.detailLab.text=_model.punish_result;
        }
        else if (indexPath.row==8){
            cell.titleLab.text=@"处罚事由";
            cell.detailLab.text=_model.punish_explain;
        }
        else if (indexPath.row==9){
            cell.titleLab.text=@"处罚依据";
            cell.detailLab.text=_model.punish_gist;
        }
        else{
            cell.titleLab.text=@"处罚期限";
            if ([DDUtils isEmptyString:_model.start_time] && [DDUtils isEmptyString:_model.end_time]) {
                cell.detailLab.text=@"-";
            }
            else{
                if (![DDUtils isEmptyString:_model.start_time] && ![DDUtils isEmptyString:_model.end_time]) {
                    cell.detailLab.text=[NSString stringWithFormat:@"%@至%@",[DDUtils getDateByPointStandardTime:_model.start_time],[DDUtils getDateByPointStandardTime:_model.end_time]];
                }
                else if([DDUtils isEmptyString:_model.start_time]){
                    cell.detailLab.text=[NSString stringWithFormat:@"-至%@",[DDUtils getDateByPointStandardTime:_model.end_time]];
                }
                else if([DDUtils isEmptyString:_model.end_time]){
                    cell.detailLab.text=[NSString stringWithFormat:@"%@至-",[DDUtils getDateByPointStandardTime:_model.start_time]];
                }
            }
        }
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return UITableViewAutomaticDimension;
    }
    else{
        if ([DDUtils isEmptyString:_model.book_num] || [_model.book_num isEqualToString:@"-"]) {//决策文书号有值，是文本形式
            if (![DDUtils isEmptyString:_model.punish_original_href]) {//附件名有值，是文本加附件形式
                return UITableViewAutomaticDimension;
            }
            else{//附件名为空，是纯文本形式
                if (indexPath.row==4) {
                    return 315;
                }
                else{
                    return UITableViewAutomaticDimension;
                }
            }
        }
        else{
           return UITableViewAutomaticDimension;
        }
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (![DDUtils isEmptyString:_model.book_num]) {//决策文书号有值，是文本形式
        if (![DDUtils isEmptyString:_model.enclosure]) {//附件名有值，是文本加附件形式
            UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 50)];
            bgView.backgroundColor=kColorWhite;
            
            UILabel *label = [UILabel labelWithFont:kFontSize30 textString:@"附件:" textColor:KColorBlackTitle textAlignment:NSTextAlignmentLeft numberOfLines:1];
            [bgView addSubview:label];
            
            UILabel *addLabel = [UILabel labelWithFont:kFontSize30 textString:_model.enclosure textColor:kColorBlue textAlignment:NSTextAlignmentLeft numberOfLines:0];
            [addLabel whenTapped:^{
                [self fileClick];
            }];
            [bgView addSubview:addLabel];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(bgView).offset(12);
                make.width.mas_equalTo(40);
                make.top.equalTo(bgView).offset(17.5);
            }];
            [addLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(bgView).offset(52);
                make.right.equalTo(bgView).offset(-12);
                make.top.equalTo(bgView).offset(17.5);
            }];
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
             UILabel *label = [UILabel labelWithFont:kFontSize30 textString:@"附件:" textColor:KColorBlackTitle textAlignment:NSTextAlignmentLeft numberOfLines:1];
             [bgView addSubview:label];
            
            UILabel *addLabel = [UILabel labelWithFont:kFontSize30 textString:_model.enclosure textColor:kColorBlue textAlignment:NSTextAlignmentLeft numberOfLines:0];
            [addLabel whenTapped:^{
                [self fileClick];
            }];
            [bgView addSubview:addLabel];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(bgView).offset(12);
                make.width.mas_equalTo(40);
                make.top.equalTo(bgView).offset(17.5);
            }];
            [addLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(bgView).offset(52);
                make.right.equalTo(bgView).offset(-12);
                make.top.equalTo(bgView).offset(17.5);
            }];
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
    if (![DDUtils isEmptyString:_model.book_num] || ![_model.book_num isEqualToString:@"-"]) {//决策文书号有值，是文本形式
        if (![DDUtils isEmptyString:_model.enclosure]) {//附件名有值，是文本加附件形式
            if(![DDUtils isEmptyString:_model.enclosure]){
                CGSize labelSize = [[NSString stringWithFormat:@"%@",_model.enclosure] boundingRectWithSize:CGSizeMake(Screen_Width-64, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:kFontSize30} context:nil].size;
                return labelSize.height+35;
            }else{
                return 50;
            }
        }
        else{//附件名为空，是纯文本形式
            return CGFLOAT_MIN;
        }
    }
    else{//决策文书号为空，是截图类型
        if (![DDUtils isEmptyString:_model.enclosure]) {//附件名有值，是截图加附件形式
            if(![DDUtils isEmptyString:_model.enclosure]){
                CGSize labelSize = [[NSString stringWithFormat:@"%@",_model.enclosure] boundingRectWithSize:CGSizeMake(Screen_Width-64, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:kFontSize30} context:nil].size;
                return labelSize.height+35;
            }else{
                return 50;
            }
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
    webView.hostTitle=@"附件查看";
    [self.navigationController pushViewController:webView animated:YES];
}

#pragma mark 点击放大
-(void)enlargePictureClick{
    NSMutableArray *array=[[NSMutableArray alloc]init];
    if (![DDUtils isEmptyString:_model.punish_original_img]) {
        [array addObject:_model.punish_original_img];
        ShowFullImageView *showFullImage=[[ShowFullImageView alloc]initWithImageUrlArray:array];
        [showFullImage show];
    }
}



@end
