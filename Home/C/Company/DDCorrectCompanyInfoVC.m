//
//  DDCorrectCompanyInfoVC.m
//  GongChengDD
//
//  Created by csq on 2018/5/28.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDCorrectCompanyInfoVC.h"
#import "UIButton+ImageFrame.h"
#import "DDAffirmEnterpriseVC.h"
#import "DDCorrectCompanyInfoTopCell.h"
#import "DDCorrectItemCell.h"
#import "DDCorrectTitleCell.h"
#import "DDCorrectInputCell.h"
#import "DDMoreImageSendCell.h"
#import "TZImagePickerController.h"
#import "DDActionSheetView.h"
#import "ShowFullImageView.h"
#import "DDAffirmEnterpriseVC.h"
#import "UIImage+extend.h"
#import "DDMyEnterpriseVC.h"
#import "DDCompanyClaimBenefitVC.h"
#define TableViewSectionHeight  30
#define AddActionSheetTag  100
#define DelectActionSheetTag  200
#define PreviewActionSheetTag  300

@interface DDCorrectCompanyInfoVC ()<UITableViewDelegate,UITableViewDataSource,DDCorrectCompanyInfoTopCellDelegate,DDMoreImageSendCellDelete,DDActionSheetViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,TZImagePickerControllerDelegate,DDCorrectItemCellDelegate,DDCorrectInputCellDerlagate>

{
    NSMutableArray * _selectedImageArr;//用户已经选择的照片数组
    NSUInteger _deleteImageTag;//要删除或替换的照片tag
    BOOL hasApplyed;
}
@property (strong,nonatomic)UITableView * tableView;
@property (strong,nonatomic)NSMutableArray *pointButtonTagArray;//选择有错的按钮tag数组
@property (copy,nonatomic)NSString * summary;//备注

@end

@implementation DDCorrectCompanyInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    hasApplyed = NO;
    _selectedImageArr = [[NSMutableArray alloc] initWithCapacity:3];
    _pointButtonTagArray = [[NSMutableArray alloc] initWithCapacity:3];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshAction) name:@"shoucirenlingchenggong" object:nil];
    
    
    self.view.backgroundColor = kColorBackGroundColor;
    self.navigationItem.title = @"纠错";
    self.navigationItem.leftBarButtonItem=[DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"返回" target:self action:@selector(leftButtonClick)];
    self.navigationItem.rightBarButtonItem = [DDUtils rightbuttonItemWithTitle:@"提交" target:self action:@selector(rightButtonClick)];

    [self setupTableView];
}
-(void)refreshAction{
    hasApplyed = YES;
}
- (void)setupTableView{
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,0, Screen_Width, Screen_Height-KNavigationBarHeight) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor=[UIColor clearColor];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
//    [self.tableView setSeparatorColor:KColorTableSeparator];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width,KTableViewFooterViewHeight)];
    [self.view addSubview:self.tableView];
}

#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 2;
    }else if (section == 2){
        return 3;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString * cellID = @"DDCorrectCompanyInfoTopCell";
        DDCorrectCompanyInfoTopCell * cell = (DDCorrectCompanyInfoTopCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:cellID owner:self options:nil] firstObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.delegate = self;
        return cell;
    }
    else if (indexPath.section == 1 && indexPath.row == 0){
        static NSString * cellID = @"DDCorrectTitleCell";
        DDCorrectTitleCell * cell = (DDCorrectTitleCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:cellID owner:self options:nil] firstObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell loadWithTitle:@"请选择信息有误的版块" subTitle:nil];
        return cell;
    }
    else if (indexPath.section == 1 && indexPath.row == 1){
        //纠错模块
        static NSString * cellID = @"DDCorrectItemCell";
        DDCorrectItemCell * cell = (DDCorrectItemCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:cellID owner:self options:nil] firstObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        //1企业证书、2人员证书、3中标业绩、4法律风险、5奖惩情况、6信用情况、7其他
        NSArray * titles = [[NSArray alloc]initWithObjects:@"企业证书",@"人员证书",@"中标业绩",@"风险信息",@"获奖荣誉",@"信用情况",@"其他", nil];
        [cell loadWithTitles:titles];
        return cell;
    }
    else if (indexPath.section == 2 && indexPath.row == 0){
        //补充说明
        static NSString * cellID = @"DDCorrectTitleCell";
        DDCorrectTitleCell * cell = (DDCorrectTitleCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:cellID owner:self options:nil] firstObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell loadWithTitle:@"补充说明" subTitle:nil];
        return cell;
    }
    else if (indexPath.section == 2 && indexPath.row == 1){
        //补充说明内容
        static NSString * cellID = @"DDCorrectInputCell";
        DDCorrectInputCell * cell = (DDCorrectInputCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        return cell;
    }
    else if (indexPath.section == 2 && indexPath.row == 2){
        //上传照片
        static NSString * cellid = @"DDMoreImageSendCell";
        DDMoreImageSendCell * cell = (DDMoreImageSendCell*)[tableView dequeueReusableCellWithIdentifier:cellid];
        if (cell == nil) {
            cell = [[DDMoreImageSendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.separatorInset = UIEdgeInsetsMake(0 0, 0, cell.bounds.size.width);
//        cell.separatorInset = UIEdgeInsetsMake(0,Screen_Width, 0, 0);
        [cell loadCellWithImage:_selectedImageArr];
        cell.delegate = self;
        return cell;
    }
    else if (indexPath.section == 3){
        static NSString * cellID = @"DDCorrectTitleCell";
        DDCorrectTitleCell * cell = (DDCorrectTitleCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:cellID owner:self options:nil] firstObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        DDUserManager * userManger = [DDUserManager sharedInstance];
        [cell loadWithTitle:@"手机号码" subTitle:userManger.mobileNumber];
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1 && indexPath.row == 1) {
        return [DDCorrectItemCell height];
    }
    if (indexPath.section == 2 && indexPath.row == 1) {
        return [DDCorrectInputCell height];
    }
    if (indexPath.section == 2 && indexPath.row == 2) {
        return [DDMoreImageSendCell heightForImageArr:_selectedImageArr];
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.01;
    }
    else{
      return 15;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

#pragma mark DDCorrectCompanyInfoTopCellDelegate
- (void)actionButtonClick:(DDCorrectCompanyInfoTopCell*)Cell{
    //如果没有认领过,才去认领
    if (hasApplyed == YES) {
        [DDUtils showToastWithMessage:@"您已认领过该公司"];
        return;
    }
    //attestation;//1已认领、2认领中 3未通认领
    if ([_passValueModel.attestation isEqualToString:@"1"]||[_passValueModel.attestation isEqualToString:@"2"]) {
        [DDUtils showToastWithMessage:@"您已认领过该公司"];
    }else if ([_passValueModel.attestation isEqualToString:@"0"]){
        DDCompanyClaimBenefitVC *vc=[[DDCompanyClaimBenefitVC alloc]init];
        vc.companyClaimBenefitType = CompanyClaimBenefitTypeCompany;
        vc.isFromMyInfo = NO;
        vc.companyid = _passValueModel.info.enterpriseId;
        vc.companyName = _passValueModel.info.enterpriseName;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([_passValueModel.attestation isEqualToString:@"-1"]){
        [DDUtils showToastWithMessage:@"您最多只能认领5家公司"];
        //跳转到"我的公司"列表
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            DDMyEnterpriseVC * vc = [[DDMyEnterpriseVC alloc] init];
            vc.myEnterpriseType = MyEnterpriseTypeDefault;
            vc.isFromMyInfo = NO;
            [self.navigationController pushViewController:vc animated:YES];
        });
    }else{
        DDCurrentCompanyModel * currentCompanyModel = [DDUserManager sharedInstance].currentCompanyModel;
        DDScAttestationEntityModel *scAttestationEntityModel = currentCompanyModel.scAttestationEntity;

        if (![DDUtils isEmptyString:scAttestationEntityModel.entId]){
            //去认领
            DDAffirmEnterpriseVC * vc = [[DDAffirmEnterpriseVC alloc] init];
            vc.companyid = _passValueModel.info.enterpriseId;
            vc.companyName = _passValueModel.info.enterpriseName;
            vc.affirmEnterpriseType = AffirmEnterpriseTypeCompany;
            vc.formMyInfoVC = NO;//从其他页面进入的
            vc.affirmEnterpriseSuccessBlock = ^{
                hasApplyed = YES;
            };
            vc.allowChangeCompanyName = NO;//不允许修改公司名
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            DDCompanyClaimBenefitVC *vc=[[DDCompanyClaimBenefitVC alloc]init];
            vc.companyClaimBenefitType = CompanyClaimBenefitTypeCompany;
            vc.isFromMyInfo = NO;
            vc.companyid = _passValueModel.info.enterpriseId;
            vc.companyName = _passValueModel.info.enterpriseName;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}
#pragma mark DDMoreImageSendCellDelete
//增加图片
-(void)cellAddImage:(DDMoreImageSendCell *)cell{
    
    DDActionSheetView* sheetView= [[DDActionSheetView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];
    sheetView.delegate = self;
    NSMutableArray * titles = [[NSMutableArray alloc]initWithCapacity:2];
    [titles addObject:charEditTakePhoto];
    [titles addObject:charEditSelectPhotoAlbum];
    [sheetView setTitle:titles cancelTitle:KMainCancel];
    sheetView.tag = AddActionSheetTag;
    [sheetView show];
}
//删除图片
-(void)cellDeleteImageWith:(DDMoreImageSendCell *)cell tag:(NSUInteger)tag{
    _deleteImageTag = 0;
    _deleteImageTag = tag;
    DDActionSheetView *sheetView = [[DDActionSheetView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 0)];
    sheetView.delegate = self;
    sheetView.tag =DelectActionSheetTag ;
    [sheetView setTitle:@[KMainDelete] cancelTitle:KMainCancel];
    [sheetView show];
    
    [self KeyboardAction];
}

//预览图片
-(void)cellPreviewImageWith:(DDMoreImageSendCell *)cell tag:(NSUInteger)tag{
    ShowFullImageView *vc = [[ShowFullImageView alloc] initWithLocalImageArray:_selectedImageArr];
    vc.showIndex = (int)tag;
    vc.pageTmpColor = kColorBlue;
    [vc show];
}

#pragma mark DDActionSheetViewDelegate
-(void)actionsheetSelectButton:(DDActionSheetView *)actionSheet buttonIndex:(NSInteger)index{
    
    
    if (actionSheet.tag == AddActionSheetTag) {
        if (1 == index) {
            [self takePhoto];
            
        }else if (2 == index){
            [self showPhotoSelectViewController];
        }
    }
    
    
    if (actionSheet.tag == DelectActionSheetTag) {
        [_selectedImageArr removeObjectAtIndex:_deleteImageTag];
        [_tableView reloadData];
    }
    
    
}

#pragma mark 拍照
- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) && iOS8Later) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:charOpenCarmeraTip delegate:self cancelButtonTitle:KMainOk otherButtonTitles:nil, nil];
        [alert show];
    } else {
        __weak __typeof(self) weakSelf=self;
        
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            return;
        }
        UIImagePickerController* controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypeCamera;
        controller.allowsEditing = YES;
        controller.delegate = self;
        [weakSelf presentViewController:controller animated:YES completion:^{
            
        }];
    }
}
#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage* image = [info objectForKey:UIImagePickerControllerEditedImage];
    UIImageWriteToSavedPhotosAlbum(image, nil,nil, nil);
    
    
    [_selectedImageArr addObject:image];
    
    // NSLog(@"拍照---");
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    //    [_tableView reloadData];
    //刷新特定row
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:2 inSection:2];
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark 从相册选择
- (void)showPhotoSelectViewController{
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:(4-_selectedImageArr.count) delegate:self];
    [imagePickerVc.navigationBar setBarTintColor:kColorBlue];
    imagePickerVc.allowPickingVideo = NO;//不能选择视频
    imagePickerVc.allowPickingOriginalPhoto = NO;//原图按钮将隐藏，用户不能选择发送原图
    imagePickerVc.showPhotoCannotSelectLayer = YES; //当照片选择张数达到maxImagesCount时，其它照片会显示浮层
    imagePickerVc.cannotSelectLayerColor = KColor70AlphaWhite;//当照片选择张数达到maxImagesCount时，其它照片的浮层颜色
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}
#pragma mark  TZImagePickerControllerDelegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
    
    
    [_selectedImageArr addObjectsFromArray:photos];
    
//    [_tableView reloadData];
    //刷新特定row
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:2 inSection:2];
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}
#pragma mark KeyboardAction
- (void)KeyboardAction{
    [self.view endEditing:YES];
}
#pragma mark 将照片压缩
- (NSMutableArray *)compressImages{
    NSMutableArray * dataArr = [[NSMutableArray alloc] initWithCapacity:3];
    
    for (UIImage * image in _selectedImageArr) {
        //压缩
        NSData *compressData = [UIImage compressDataWithImage:image maxLength:kFileMaxSize];
        [dataArr addObject:compressData];
    }
    
    return dataArr;
}
#pragma mark 提交
- (void)rightButtonClick{
    //参数校验
    if (0 == _pointButtonTagArray.count) {
        [DDUtils showToastCoverKeyboard:@"请选择信息有误的版块"];
        return;
    }
//    if (0 == _selectedImageArr.count ) {
//        [DDUtils showToastCoverKeyboard:@"请上传图片"];
//        return;
//    }
    if ([DDUtils isEmptyString:_summary] || _summary.length < 10) {
        [DDUtils showToastCoverKeyboard:@"请填写10字之上的补充说明"];
        return;
    }
    //对字数做下限制
    if (_summary.length > 200) {
        [DDUtils showToastCoverKeyboard:@"请输入200字之内的补充说明"];
        return;
    }
    
    if (_selectedImageArr.count == 0) {
        //没有图片
        [self addInfo:nil];
    }else{
        //先上传图片,再提交审核
        [self uploadImage];
    }
}

- (void)uploadImage{
    //提交图片
    //时间
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *dateStr = [formatter stringFromDate:date];
    
    
    //图片压缩下
    NSMutableArray * compressImageArr = [self compressImages];
    
    MBProgressHUD * hud = [DDUtils showHUDCoverKeyboard:@""];
    [[DDHttpManager sharedInstance] sendPostRequestWithFile:KHttpRequest_imgUpload params:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        for (int i = 0; i< compressImageArr.count; i++) {
            NSData * data = compressImageArr[i];
            NSString * fileNameString = [NSString stringWithFormat:@"%@%d.jpg",dateStr,i];
            [formData appendPartWithFileData:data name:@"file" fileName:fileNameString mimeType:@"jpg"];
            NSLog(@"___fileNameString:%@",fileNameString);
        }
    } success:^(NSURLSessionDataTask *operation, id responseObject) {
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {
            [hud hide:YES];
            
            if ([response.data isKindOfClass:[NSArray class]]) {
                
                //上传图片成功后,再提交认证
                [self addInfo:response.data];
            }
            
        }else{
            hud.labelText = response.message;
            [hud hide:YES afterDelay:KHudShowTimeSecound];
        }
        
    } failure:^(NSURLSessionDataTask *operation, id responseObject) {
        hud.labelText = @"上传图片失败";
        [hud hide:YES afterDelay:KHudShowTimeSecound];
    }];
    

}
- (void)addInfo:(NSArray*)imagesData{
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
    //使用,拼接
    NSString * cortType = @"";
    for (NSString * buttonTag in _pointButtonTagArray) {
        cortType = [cortType stringByAppendingFormat:@"%@,",buttonTag];
    }
    cortType = cortType;
    
    [params setValue:cortType forKey:@"cortType"];//纠错类型 1企业证书、2人员证书、3中标业绩、4法律风险、5奖惩情况
    [params setValue:_passValueModel.info.enterpriseId forKey:@"entId"];
    [params setValue:_summary forKey:@"summary"];
    DDUserManager * userManger = [DDUserManager sharedInstance];
    [params setValue:userManger.mobileNumber forKey:@"tel"];
    [params setValue:userManger.userid forKey:@"userId"];
    
 
    if (imagesData.count>0) {
        //有图片,才添加,
        NSMutableArray * fsIdArr = [[NSMutableArray alloc]initWithCapacity:3];
        for (NSDictionary * dic in imagesData) {
            [fsIdArr addObject:dic[@"id"]];
        }
        [params setValue:fsIdArr forKey:@"fsId"];
    }else{
        NSArray * array = [[NSArray alloc] init];
        [params setValue:array forKey:@"fsId"];
    }
 
    
    MBProgressHUD * hud = [DDUtils showHUDCoverKeyboard:@""];
    [[DDHttpManager sharedInstance] sendPostRequest:KHttpRequest_corcorrectionSave params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {
            hud.labelText = @"提交成功";
            hud.completionBlock = ^{
                [self leftButtonClick];
            };
        }else{
            hud.labelText = response.message;
        }
        [hud hide:YES afterDelay:KHudShowTimeSecound];
    } failure:^(NSURLSessionDataTask *operation, id responseObject) {
        hud.labelText = kRequestFailed;
        [hud hide:YES afterDelay:KHudShowTimeSecound];
    }];
}
#pragma mark DDCorrectItemCellDelegate 选择信息有误cell代理

//选择了错误模块
- (void)selectInfoErroeItem:(DDCorrectItemCell*)cell pointButtonTagArray:(NSArray*)pointButtonTagArray{
    NSLog(@"选择了错误模块 %@",pointButtonTagArray);
    [_pointButtonTagArray removeAllObjects];
    [_pointButtonTagArray addObjectsFromArray:pointButtonTagArray];
}
#pragma mark DDCorrectInputCellDerlagate 补充说明cell代理
//输入框内容已经改变
- (void)correctInputCellDidChange:(DDCorrectInputCell*)cell text:(NSString*)text{
    _summary = text;
}
- (void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}





@end
