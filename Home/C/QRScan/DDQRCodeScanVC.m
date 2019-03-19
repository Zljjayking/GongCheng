//
//  DDQRCodeScanVC.m
//  GongChengDD
//
//  Created by xzx on 2018/5/8.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDQRCodeScanVC.h"
#import <AVFoundation/AVFoundation.h>
#import "DDQRCodeScanResultVC.h"//扫描结果页面
#import "DDQRCodeScanResult2VC.h"//扫描的不是PC端登录的二维码
#import "DDQRCodeScanModel.h"


@interface DDQRCodeScanVC ()<AVCaptureMetadataOutputObjectsDelegate>

//扫描框
@property (nonatomic, strong) UIView * view_bg;
////扫描线
//@property (nonatomic, strong) CALayer * layer_scanLine;
//扫描线
@property (nonatomic, strong) UIImageView * layer_scanLine;
//提示语
@property (nonatomic, strong) UILabel * lab_word;
    
@property (nonatomic, strong) NSTimer * timer;
    
//采集的设备
@property (strong,nonatomic) AVCaptureDevice * device;
//设备的输入
@property (strong,nonatomic) AVCaptureDeviceInput * input;
    //输出
@property (strong,nonatomic) AVCaptureMetadataOutput * output;
//采集流
@property (strong,nonatomic) AVCaptureSession * session;
//窗口
@property (strong,nonatomic) AVCaptureVideoPreviewLayer * previewLayer;
@property (strong,nonatomic)DDQRCodeScanModel * qrCodeScanModel;

    
@end

@implementation DDQRCodeScanVC

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.translucent=YES;
    //设置导航栏背景图片为一个空的image，这样就透明了
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}

-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.translucent = NO;
    //如果不想让其他页面的导航栏变为透明 需要重置
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.navigationItem.title = @"二维码扫描";
    //self.navigationItem.leftBarButtonItem = [DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"返回" target:self action:@selector(leftButtonClick)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(leftButtonClick)];
    self.navigationItem.leftBarButtonItem.tintColor =kColorWhite;
    [self startScan];
}

#pragma mark --返回上一页
- (void)leftButtonClick{
  
    
    [self.timer invalidate];
    self.timer = nil;
    [self.navigationController popViewControllerAnimated:YES];
}
//取消二维码扫描
- (void)cancelScan{
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [params setValue:_qrCodeScanModel.ticket forKey:@"ticket"];
    
    [[DDHttpManager sharedInstance] sendPostRequest:KHttpRequest_cancelQrLogin params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {
            NSLog(@"取消二维码扫描登录,成功");
        }else{
            NSLog(@"取消二维码扫描登录,异常%@",response.message);
        }
    } failure:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"取消二维码扫描登录,失败");
    }];
    
}
#pragma mark 初始化
- (void)startScan {
    // Device 实例化设备   //获取摄像设备
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input 设备输入     //创建输入流
    _input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:nil];
    
    // Output 设备的输出  //创建输出流
    _output = [[AVCaptureMetadataOutput alloc]init];
    
    //设置代理   在主线程里刷新
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // Session         //初始化链接对象
    _session = [[AVCaptureSession alloc]init];
    
    //高质量采集率
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    
    //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
    // 二维码类型 AVMetadataObjectTypeQRCode
    _output.metadataObjectTypes =@[AVMetadataObjectTypeCode128Code,AVMetadataObjectTypeUPCECode,AVMetadataObjectTypeCode39Code,AVMetadataObjectTypeCode39Mod43Code,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeCode93Code,AVMetadataObjectTypePDF417Code,AVMetadataObjectTypeQRCode,AVMetadataObjectTypeAztecCode,AVMetadataObjectTypeInterleaved2of5Code,AVMetadataObjectTypeITF14Code,AVMetadataObjectTypeDataMatrixCode];
    
    // Preview 扫描窗口设置
    _previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    _previewLayer.frame = CGRectMake(0, 0, Screen_Width, Screen_Height);
    
    _output.rectOfInterest = CGRectMake(0.15, 0.25, 0.7, 0.5);
    
    [self.view.layer insertSublayer:_previewLayer atIndex:0];
    
    //添加框和线
    [self addSubviews];
    [self makeConstraintsForUI];
    // Start 开始扫描   //开始捕获
    [_session startRunning];
    
    self.timer.fireDate = [NSDate distantPast];
}
    
#pragma mark 添加View
- (void)addSubviews {
    [self.view addSubview:self.view_bg];
    [self.view addSubview:self.lab_word];
    //[_view_bg.layer addSublayer:self.layer_scanLine];
    [_view_bg addSubview:self.layer_scanLine];
}
    
#pragma mark 添加约束
- (void)makeConstraintsForUI {
    
    //_view_bg.frame=CGRectMake(0.15 * Screen_Width, 0.25 * (Screen_Height - 64) - 32, 0.7 * Screen_Width, 0.5 * (Screen_Height - 64));
    _view_bg.frame=CGRectMake((Screen_Width-262)/2, 153, 262, 262);
    
    UIImageView *boxImg=[[UIImageView alloc]initWithFrame:_view_bg.frame];
    boxImg.image=[UIImage imageNamed:@"home_scanBox"];
    [self.view addSubview:boxImg];
    
//    [_view_bg mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.size.mas_equalTo(CGSizeMake(0.7 * Screen_Width,  0.5 * (Screen_Height - 64)));
//
//        make.left.mas_equalTo(@(0.15 * Screen_Width));
//
//        make.top.mas_equalTo(@(0.25 * (Screen_Height - 64) - 32));
//    }];
    
    
    _lab_word.frame=CGRectMake(0, CGRectGetMaxY(_view_bg.frame)+105, Screen_Width, 21);
    
    
//    [_lab_word mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.size.mas_equalTo(CGSizeMake(Screen_Width, 21));
//
//        make.left.mas_equalTo(@0);
//
//        make.top.mas_equalTo(_view_bg.mas_bottom).with.offset(20);
//    }];
    
}
    
#pragma mark AVCaptureMetadataOutputObjectsDelegate代理方法
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    //得到解析到的结果
    NSString * stringValue;
    
    if (metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject * metadataObject = metadataObjects.firstObject;
        stringValue = metadataObject.stringValue;
    }

    //停止扫描
    [_session stopRunning];
    
    self.timer.fireDate = [NSDate distantFuture];
    
    
    if ([stringValue containsString:@"ticket"] && [stringValue containsString:@"cdt"] && [stringValue containsString:@"expire"]) {
        
        //
         _qrCodeScanModel=[[DDQRCodeScanModel alloc]initWithDictionary:[self dictionaryWithUrlString:stringValue] error:nil];
        
        __weak __typeof(self) weakSelf=self;
        DDQRCodeScanResultVC *codeScanResult=[[DDQRCodeScanResultVC alloc]init];
        codeScanResult.stringValue=stringValue;
        codeScanResult.cancelBlock = ^{
            [_session startRunning];
            weakSelf.timer.fireDate = [NSDate distantPast];
            
            //取消二维码扫描
            [weakSelf cancelScan];
        };
        codeScanResult.scanSuccessBlock = ^{
            [_previewLayer removeFromSuperlayer];
            [self.timer invalidate];
            _timer = nil;
        };
        [self.navigationController pushViewController:codeScanResult animated:YES];
    }
    else{
        DDQRCodeScanResult2VC *QRCodeScanResult2=[[DDQRCodeScanResult2VC alloc]init];
        QRCodeScanResult2.hostUrl=stringValue;
        QRCodeScanResult2.backBlock = ^{
            [_session startRunning];
            
            self.timer.fireDate = [NSDate distantPast];
        };
        [self.navigationController pushViewController:QRCodeScanResult2 animated:YES];
        
        
//            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请扫描正确二维码" preferredStyle:UIAlertControllerStyleAlert];
//
//            UIAlertAction * actionCancel = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//                [_previewLayer removeFromSuperlayer];
//
//                [self.timer invalidate];
//
//                _timer = nil;
//
//                [self dismissViewControllerAnimated:YES completion:nil];
//
//                [self.navigationController popViewControllerAnimated:YES];
//
//
//            }];
//
//            UIAlertAction * actionReStart = [UIAlertAction actionWithTitle:@"重新扫描" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//                [_session startRunning];
//
//                self.timer.fireDate = [NSDate distantPast];
//
//            }];
//
//            [alertController addAction:actionCancel];
//            [alertController addAction:actionReStart];
//            [self presentViewController:alertController animated:YES completion:nil];
    }

    
    
//    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"结果：%@", stringValue] preferredStyle:UIAlertControllerStyleAlert];
//
//    UIAlertAction * actionCancel = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//        [_previewLayer removeFromSuperlayer];
//
//        [self.timer invalidate];
//
//        _timer = nil;
//
//        [self dismissViewControllerAnimated:YES completion:nil];
//
//        [self.navigationController popViewControllerAnimated:YES];
//
//
//    }];
//
//    UIAlertAction * actionReStart = [UIAlertAction actionWithTitle:@"重新扫描" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//        [_session startRunning];
//
//        self.timer.fireDate = [NSDate distantPast];
//
//    }];
//
//    [alertController addAction:actionCancel];
//    [alertController addAction:actionReStart];
//    [self presentViewController:alertController animated:YES completion:nil];
}
    
#pragma mark 懒加载
- (UIView *)view_bg {
    if (!_view_bg) {
        _view_bg = [[UIView alloc] init];
        
        _view_bg.layer.borderColor = [UIColor whiteColor].CGColor;
        
        _view_bg.layer.borderWidth = 1.0;
    }
    
    return _view_bg;
}
    
//- (CALayer *)layer_scanLine {
//    if (!_layer_scanLine) {
//        CALayer * layer = [[CALayer alloc] init];
//
//        layer.bounds = CGRectMake(0, 0, 262, 1.5);
//
//        layer.backgroundColor = [UIColor greenColor].CGColor;
//
//        //起点
//        layer.position = CGPointMake(0, 0);
//
//        //定位点
//        layer.anchorPoint = CGPointMake(0, 0);
//
//        _layer_scanLine = layer;
//    }
//
//    return _layer_scanLine;
//}

- (UIImageView *)layer_scanLine {
    if (!_layer_scanLine) {
        UIImageView * layer = [[UIImageView alloc] init];
        
        layer.bounds = CGRectMake(0, 0, 262, 6);
        
        layer.image=[UIImage imageNamed:@"home_scanLine"];
        
        //起点
        layer.layer.position = CGPointMake(0, 0);
        
        //定位点
        layer.layer.anchorPoint = CGPointMake(0, 0);
        
        _layer_scanLine = layer;
    }
    
    return _layer_scanLine;
}
    
- (UILabel *)lab_word {
    if (!_lab_word) {
        _lab_word = [[UILabel alloc] init];
        
        _lab_word.textAlignment = NSTextAlignmentCenter;
        
        _lab_word.textColor = [UIColor whiteColor];
        
        _lab_word.font = kFontSize32;
        
        _lab_word.text = @"支持扫码快速登录电脑版工程点点";
    }
    
    return _lab_word;
}
    
#pragma mark 定时器
- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(scanLineMove) userInfo:nil repeats:YES];
        [_timer fire];
    }
    
    return _timer;
}


- (void)scanLineMove {
    CABasicAnimation * animation = [[CABasicAnimation alloc] init];
    
    //告诉系统要执行什么样的动画
    animation.keyPath = @"position";
    
    //设置通过动画  layer从哪到哪
    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(0, 0)];
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(0, 256)];
    
    //动画时间
    animation.duration = 2.0;
    
    //设置动画执行完毕之后不删除动画
    animation.removedOnCompletion = NO;
    
    //设置保存动画的最新动态
    animation.fillMode = kCAFillModeForwards;
    
    //添加动画到layer
    [self.layer_scanLine.layer addAnimation:animation forKey:nil];
}
    
    
#pragma mark ---
-(NSDictionary *)dictionaryWithUrlString:(NSString *)urlStr{
    if (urlStr && urlStr.length && [urlStr rangeOfString:@"?"].length == 1) {
        NSArray *array = [urlStr componentsSeparatedByString:@"?"];
        if (array && array.count == 2) {
            NSString *paramsStr = array[1];
            if (paramsStr.length) {
                NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
                NSArray *paramArray = [paramsStr componentsSeparatedByString:@"&"];
                for (NSString *param in paramArray) {
                    if (param && param.length) {
                        NSArray *parArr = [param componentsSeparatedByString:@"="];
                        if (parArr.count == 2) {
                            [paramsDict setObject:parArr[1] forKey:parArr[0]];
                        }
                    }
                }
                return paramsDict;
            }else{
                return nil;
            }
        }else{
            return nil;
        }
    }else{
        return nil;
    }
}

@end
