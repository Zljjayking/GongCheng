//
//  DDAddressManagerVC.m
//  GongChengDD
//
//  Created by xzx on 2018/7/3.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDAddressManagerVC.h"
#import "MJRefresh.h"
#import "DataLoadingView.h"//加载页面
#import "DDNoResult2View.h"//无数据视图
#import "DDAddressManageCell.h"//cell

#import "DDNewAddAddressVC.h"//新增地址
#import "DDEditAddressVC.h"//编辑地址

@interface DDAddressManagerVC ()<UITableViewDelegate,UITableViewDataSource>

{
    NSInteger currentPage;
    NSInteger pageCount;
    NSMutableArray *_dataSourceArr;
    NSMutableDictionary *_dict;
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) DataLoadingView *loadingView;
@property (nonatomic,strong) DDNoResult2View *noResultView;//无数据视图

@end

@implementation DDAddressManagerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataSourceArr=[[NSMutableArray alloc]init];
    self.view.backgroundColor=kColorBackGroundColor;
    self.title=@"地址管理";
    self.navigationItem.leftBarButtonItem=[DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"返回" target:self action:@selector(leftButtonClick)];
    self.navigationItem.rightBarButtonItem=[DDUtils rightbuttonItemWithTitle:@"新增地址" target:self action:@selector(newAddAddressClick)];
    [self createTableView];
    [self createLoadView];
    [self requestData];
}

//返回上一页
- (void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

//新增地址
-(void)newAddAddressClick{
    DDNewAddAddressVC *newAddAddress=[[DDNewAddAddressVC alloc]init];
    newAddAddress.addBlock = ^{
        [self requestData];
    };
    [self.navigationController pushViewController:newAddAddress animated:YES];
}

#pragma mark 创建加载视图
-(void)createLoadView{
    __weak __typeof(self) weakSelf=self;
    _noResultView=[[DDNoResult2View alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-KNavigationBarHeight)];
    [self.view addSubview:_noResultView];
    
    _loadingView = [[DataLoadingView alloc] initWithController:self];
    _loadingView.loadingTitle = KLoading;
    _loadingView.failureTitle = KLoadingFailure;
    _loadingView.reloadHandle = ^(void){
        [weakSelf requestData];
    };
    [_loadingView showLoadingView];
}

//创建tableView
-(void)createTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-KNavigationBarHeight) style:UITableViewStyleGrouped];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.showsVerticalScrollIndicator=NO;
    [self.view addSubview:_tableView];
    _tableView.estimatedRowHeight=44;
    _tableView.separatorColor=KColorTableSeparator;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, KTableViewFooterViewHeight)];
    
    __weak __typeof(self) weakSelf=self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requestData];
    }];
}

#pragma mark 请求数据
- (void)requestData{
    currentPage = 1;
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
    [params setValue:[NSString stringWithFormat:@"%ld",currentPage] forKey:@"current"];
    [params setValue:@"10" forKey:@"size"];
    
    
    [[DDHttpManager sharedInstance]sendGetRequest:KHttpRequest_addressManagerList params:params success:^(NSURLSessionDataTask *operation, id responseObject){
        NSLog(@"**********地址列表结果数据***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        __weak __typeof(self) weakSelf = self;
        if (response.isSuccess) {
            [_dataSourceArr removeAllObjects];
            [_loadingView hiddenLoadingView];
            _dict = responseObject[KData];
            pageCount = [_dict[@"totalCount"] integerValue];
            NSArray *listArr=_dict[@"list"];
            
            
            if (listArr.count!=0) {
                [_noResultView hide];
                
                for (NSDictionary *dic in listArr) {
                    DDAddressManagerModel *model = [[DDAddressManagerModel alloc]initWithDictionary:dic error:nil];
                    [_dataSourceArr addObject:model];
                }
                
                if (listArr.count<pageCount) {
                    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                        [weakSelf addData];
                    }];
                }else{
                   [_tableView.mj_footer removeFromSuperview];
                }
            }
            else{
                [_noResultView showWithTitle:@"暂无地址信息" subTitle:@"去添加吧~" image:@"noResult_content"];
            }
            
        }
        else{
            [_loadingView failureLoadingView];
        }
        
        [self.tableView.mj_header endRefreshing];
        [_tableView reloadData];
        
    }  failure:^(NSURLSessionDataTask *operation, id responseObject)  {
        [DDUtils showToastWithMessage:kRequestFailed];
        [_loadingView failureLoadingView];
    }];
}

- (void)addData{
    currentPage++;
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [params setValue:[NSString stringWithFormat:@"%ld",currentPage] forKey:@"current"];
    [params setValue:@"10" forKey:@"size"];
    
    
    [[DDHttpManager sharedInstance]sendGetRequest:KHttpRequest_addressManagerList params:params success:^(NSURLSessionDataTask *operation, id responseObject){
        NSLog(@"**********地址列表结果数据***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        __weak __typeof(self) weakSelf = self;
        if (response.isSuccess) {
            
            _dict = responseObject[KData];
            NSArray *listArr = _dict[@"list"];
            for (NSDictionary *dic in listArr) {
                DDAddressManagerModel *model = [[DDAddressManagerModel alloc]initWithDictionary:dic error:nil];
                [_dataSourceArr addObject:model];
            }
            
            if (_dataSourceArr.count<pageCount) {
                self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                    [weakSelf addData];
                }];
            }
            else{
              [_tableView.mj_footer removeFromSuperview];
            }
        }
        else{
            [DDUtils showToastWithMessage:response.message];
        }
        
        //[self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
        
    }  failure:^(NSURLSessionDataTask *operation, id responseObject)  {
        [DDUtils showToastWithMessage:kRequestFailed];
    }];
}

#pragma mark tableView代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataSourceArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DDAddressManagerModel *model=_dataSourceArr[indexPath.section];
    
    static NSString * cellID = @"DDAddressManageCell";
    DDAddressManageCell * cell = (DDAddressManageCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
    }
    
    cell.nameLab.text=model.receiver;
    cell.telLab.text=model.tel;
    
    if ([model.province isEqualToString:model.city]) {
        
        cell.addressLab.text=[NSString stringWithFormat:@"%@ %@ %@",model.city, model.area,model.detail];
    } else {
        cell.addressLab.text=[NSString stringWithFormat:@"%@ %@ %@ %@",model.province,model.city,model.area,model.detail];
    }
    
    
    if ([model.is_default isEqualToString:@"1"]) {
        cell.defaultImg.image=[UIImage imageNamed:@"home_address_default"];
    }
    else{
        cell.defaultImg.image=[UIImage imageNamed:@"home_address_noDefault"];
    }
    
    cell.defaultBtn.tag=indexPath.section+150;
    cell.editBtn.tag=indexPath.section+250;
    cell.deleteBtn.tag=indexPath.section+350;
    [cell.defaultBtn addTarget:self action:@selector(setDefaultAddress:) forControlEvents:UIControlEventTouchUpInside];
    [cell.editBtn addTarget:self action:@selector(editAddress:) forControlEvents:UIControlEventTouchUpInside];
    [cell.deleteBtn addTarget:self action:@selector(deleteAddress:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_addressType == DDAddressTypeSet) {
        return;
    }
    DDAddressManagerModel *model=_dataSourceArr[indexPath.section];
    if (self.addressSelectBlock) {
        self.addressSelectBlock(model);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * header = [[UIView alloc] init];
    header.frame = CGRectMake(0, 0, Screen_Width, 15);
    return header;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

#pragma mark 设置默认地址
-(void)setDefaultAddress:(UIButton *)sender{
    DDAddressManagerModel *model=_dataSourceArr[sender.tag-150];
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [params setValue:model.history_address_id forKey:@"historyAddressId"];
    [params setValue:@"1" forKey:@"isDefault"];
    
    MBProgressHUD * hud = [DDUtils showHUDCustom:@""];
    [[DDHttpManager sharedInstance]sendPostRequest:KHttpRequest_editAddress params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"**********设置默认地址***************%@",responseObject);
        
        __weak __typeof(self) weakSelf=self;
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {
            hud.mode = MBProgressHUDModeCustomView;
            hud.customView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cer_success"]];
            hud.labelText=@"设置成功";
            hud.completionBlock= ^(){
                [weakSelf requestData];
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

#pragma mark 编辑地址
-(void)editAddress:(UIButton *)sender{
    DDAddressManagerModel *model=_dataSourceArr[sender.tag-250];
 
    DDEditAddressVC *editAddress=[[DDEditAddressVC alloc]init];
    editAddress.historyAddressId=model.history_address_id;
    editAddress.isDefault=model.is_default;
    editAddress.addBlock = ^{
        [self requestData];
    };
    [self.navigationController pushViewController:editAddress animated:YES];
}

#pragma mark 删除地址
-(void)deleteAddress:(UIButton *)sender{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"确认删除改地址吗" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        DDAddressManagerModel *model=_dataSourceArr[sender.tag-350];
        
        NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
        [params setValue:model.history_address_id forKey:@"historyAddressId"];
        
        MBProgressHUD * hud = [DDUtils showHUDCustom:@""];
        [[DDHttpManager sharedInstance]sendGetRequest:KHttpRequest_deleteAddress params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
            NSLog(@"***********删除地址请求***************%@",responseObject);
            
            __weak __typeof(self) weakSelf=self;
            DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
            if (response.isSuccess) {
                hud.mode = MBProgressHUDModeCustomView;
                hud.customView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cer_success"]];
                hud.labelText=@"删除成功";
                hud.completionBlock= ^(){
                    [weakSelf requestData];
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
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alert addAction:action1];
    [alert addAction:action2];
    
    [self presentViewController:alert animated:YES completion:nil];
   
}



@end
