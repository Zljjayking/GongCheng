//
//  DDTrainInputCompanyNameVC.m
//  GongChengDD
//
//  Created by xzx on 2018/7/19.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDTrainInputCompanyNameVC.h"
#import "DDAffirmEnterpriseInputCell.h"//cell


@interface DDTrainInputCompanyNameVC ()<UITableViewDelegate,UITableViewDataSource,DDAffirmEnterpriseInputCellDelegate>

{
    NSString *_companyName;
    NSString *_companyId;
}
@property (strong ,nonatomic) DDAffirmEnterpriseInputCell *companyInfoCell;
@property(nonatomic,strong) UITableView *tableView;
@property (strong,nonatomic) NSMutableArray *searchCompanys;//搜索到的公司数组
@property (strong,nonatomic) UITableView *searchResultTableView;//搜索到公司的tableView
@property (assign,nonatomic) CGFloat kerboardHeight;//键盘高度

@property (copy, nonatomic)NSString * realName;//真实姓名
@property (copy, nonatomic)NSString * tel;
@property (copy, nonatomic)NSString * email;
/**
 搜索关键字
 */
@property (strong,nonatomic)NSString * searchKeyWord;
/**
 选择的公司模型
 */
@property (strong, nonatomic)  DDSearchCompanyModel *selectCompanyModel;

@end

@implementation DDTrainInputCompanyNameVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self editNavItem];
    [self createTableView];
    [self addkeyboardObserver];
}

-(void)editNavItem{
    self.view.backgroundColor=kColorBackGroundColor;
    
    _searchCompanys=[[NSMutableArray alloc]init];
    if ([_type isEqualToString:@"1"]) {
        
    }else{
        self.title=@"填写单位名称";
    }
  
    self.navigationItem.leftBarButtonItem=[DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"返回" target:self action:@selector(leftButtonClick)];
    self.navigationItem.rightBarButtonItem=[DDUtils rightbuttonItemWithTitle:@"完成" target:self action:@selector(finishClick)];
}

//返回上一页
- (void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

//增加键盘监听
- (void)addkeyboardObserver{
    //监听弹出键盘
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShowAction:) name:UIKeyboardDidShowNotification object:nil];
    //监听隐藏键盘
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHideAction:) name:UIKeyboardDidHideNotification object:nil];
}
//键盘已经显示
- (void)keyboardDidShowAction:(NSNotification *)aNotification{
    //创建自带来获取穿过来的对象的info配置信息
    NSDictionary *userInfo = [aNotification userInfo];
    
    //创建value来获取 userinfo里的键盘frame大小
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    //创建cgrect 来获取键盘的值
    CGRect keyboardRect = [aValue CGRectValue];
    
    //最后获取高度 宽度也是同理可以获取
    CGFloat height = keyboardRect.size.height;
    
    //把高度用_kerboardHeight保存起来
    _kerboardHeight = height;
}

//键盘隐藏时
- (void)keyboardDidHideAction:(NSNotification *)aNotification{
    
}

//点击完成
-(void)finishClick{
    [self.view endEditing:YES];
    _companyName=_companyInfoCell.inputTextFileld.text;
    
    if (![_companyName isEqualToString:_selectCompanyModel.enterpriseName]) {
        _selectCompanyModel = [[DDSearchCompanyModel alloc] init];
        _selectCompanyModel.enterpriseId = @"";
        _selectCompanyModel.taxNumber = @"";
    }
    
    _selectCompanyModel.enterpriseName = _companyName;
    if ([DDUtils isEmptyString:_companyName]) {
        [DDUtils showToastWithMessage:@"请填写或选择公司"];
        return;
    }
    if (_companyName.length>50) {
        [DDUtils showToastWithMessage:@"最多输入50字"];
        return;
    }
    else{
        if (self.companyBlock) {
             self.companyBlock(_companyName, _companyId);
        }
        if (self.finshBlock) {
           self.finshBlock(_selectCompanyModel);
        }
       
    }
    [self.navigationController popViewControllerAnimated:YES];
}

//创建tableView
-(void)createTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-KNavigationBarHeight) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=kColorBackGroundColor;
    _tableView.showsVerticalScrollIndicator=YES;
    _tableView.scrollEnabled=NO;
    _tableView.separatorColor=KColorTableSeparator;
}

#pragma mark tableView代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView==_tableView) {
        return 1;
    }
    else{
        return _searchCompanys.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==_tableView) {
        //企业全称
        static NSString * cellID = @"DDAffirmEnterpriseInputCell";
        _companyInfoCell = (DDAffirmEnterpriseInputCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
        if (_companyInfoCell == nil) {
            _companyInfoCell = [[[NSBundle mainBundle] loadNibNamed:cellID owner:self options:nil] firstObject];
        }
        
        //_companyInfoCell.inputTextFileld.returnKeyType = UIReturnKeySearch;
        
        [_companyInfoCell loadWithTitle:@"单位名称" placeholder:@"请输入单位名称" markName:nil indexPath:indexPath andContentStr:_contentStr];
        _companyInfoCell.delegate = self;
        
        [_companyInfoCell.inputTextFileld addTarget:self action:@selector(observeTextChange) forControlEvents:UIControlEventEditingChanged];
        _companyInfoCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return _companyInfoCell;
    }
    else{
        //搜索结果cell
        static NSString * cellId = @"searchResult";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.textLabel.textColor = KColorBlackTitle;
        cell.textLabel.font = kFontSize32;
        DDSearchCompanyModel * model = _searchCompanys[indexPath.row];
        
        //加载HTML
        NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithData:[model.unitName dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        //设置文本的字体大小
        [content addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.0f] range:NSMakeRange(0, content.length)];
        cell.textLabel.attributedText = content;
        
        cell.detailTextLabel.textColor = KColorBlackTitle;
        cell.detailTextLabel.font = kFontSize32;
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]];
        return cell;
    }
}

#pragma mark 监听输入框文字改变
-(void)observeTextChange{
    _companyId=@"";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _tableView) {
        
    }
    else{
        //拿到公司数据
        _selectCompanyModel = _searchCompanys[indexPath.row];
        //NSLog(@"点击了,第%ld行,公司名:%@",indexPath.row,_selectCompanyModel.enterpriseName);
        
        //把键盘隐藏,
        [self.view endEditing:YES];
        
        //隐藏搜索tabelView
        self.searchResultTableView.hidden=YES;
        
        //把公司名称,赋值给输入框
        _companyInfoCell.inputTextFileld.text=_selectCompanyModel.enterpriseName;
        
        _companyName=_selectCompanyModel.enterpriseName;
        _companyId=_selectCompanyModel.enterpriseId;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==_tableView) {
        return 47;
    }
    else{
        return 44;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView==_tableView) {
        return 15;
    }
    else{
        return CGFLOAT_MIN;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

//创建搜索结果tableView
- (void)creatSearchTableView:(CGFloat)height{
    if (!_searchResultTableView) {
        self.searchResultTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,15+47, Screen_Width,Screen_Height-KNavigationBarHeight-height-(15+47)) style:UITableViewStyleGrouped];
        self.searchResultTableView.backgroundColor = [UIColor clearColor];
        self.searchResultTableView.delegate = self;
        self.searchResultTableView.dataSource = self;
        [self.tableView setSeparatorColor:KColorTableSeparator];
        //    self.searchResultTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:self.searchResultTableView];
    }
    //显示searchResultTableView
    self.searchResultTableView.hidden = NO;
}

#pragma mark  cell输入代理 DDAffirmEnterpriseInputCellDelegate
//输入框内容改变了
- (void)inputTextFieldShouldChangeCharacters:(NSString*)text indexPath:(NSIndexPath *)indexPath{
    if (0 == indexPath.row) {
        //创建搜索结果tableView
        [self creatSearchTableView:_kerboardHeight];
        
        //如果关键字为空,清除搜索数据源,隐藏搜索结果表
        if (text.length == 0) {
            [_searchCompanys removeAllObjects];
            self.searchResultTableView.hidden = YES;
        }
        
        //大于2个字时候,搜索公司列表
        if (text.length>=2) {
            //把关键字,赋值给全局变量
            _searchKeyWord = text;
            [self searchCompanysWithKeyWord:text];
        }
    }
}
//输入框结束输入
- (void)inputTextFieldDidEndEditing:(NSString*)text indexPath:(NSIndexPath *)indexPath{
    if (1 == indexPath.row) {
        _realName = text;
    }
    if (3 == indexPath.row) {
        _email = text;
    }
}

#pragma mark 关键字搜索公司
- (void)searchCompanysWithKeyWord:(NSString*)keyWord{
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
    [params setValue:keyWord forKey:@"keys"];
    
    [[DDHttpManager sharedInstance] sendPostRequest:KHttpRequest_queryAllCompanyByKey params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"公司搜索结果:%@",responseObject);
        
        //删除数据
        [_searchCompanys removeAllObjects];
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {
            
            if ([response.data isKindOfClass:[NSArray class]]) {
                NSArray *arr = [DDSearchCompanyModel arrayOfModelsFromDictionaries:response.data error:nil];
                [_searchCompanys addObjectsFromArray:arr];
            }
            
            //搜索如果没有结果,隐藏搜索结果tableView
            //搜索如果有结果,显示搜索结果tableView
            
            if (_searchCompanys.count == 0) {
//                hud.labelText = @"暂无此企业信息";
                self.searchResultTableView.hidden  = YES;
            }
            else{
                self.searchResultTableView.hidden  = NO;
            }
            
        }
        else{
//            hud.labelText = response.message;
        }
        
        //刷新结果
        [_searchResultTableView reloadData];
//        [hud hide:YES afterDelay:KHudShowTimeSecound];
        
    } failure:^(NSURLSessionDataTask *operation, id responseObject) {
        MBProgressHUD * hud = [DDUtils showHUDCoverKeyboard:@""];
        hud.labelText = kRequestFailed;
        [hud hide:YES afterDelay:KHudShowTimeSecound];
    }];
}




@end
