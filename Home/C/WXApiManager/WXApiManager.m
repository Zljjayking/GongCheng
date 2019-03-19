//
//  WXApiManager.m
//  SDKSample
//
//  Created by Jeason on 16/07/2015.
//
//

#import "WXApiManager.h"

@implementation WXApiManager

#pragma mark - LifeCycle
+(instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static WXApiManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[WXApiManager alloc] init];
    });
    return instance;
}

#pragma mark - WXApiDelegate
- (void)onResp:(BaseResp *)resp {
    if([resp isKindOfClass:[PayResp class]]){
        
        //NSLog(@"微信返回结果*******%@",resp);
        //PayResp *re=(PayResp *)resp;
        //NSLog(@"微信returnKey==== *****************%@",re.returnKey);
        
        NSString *noSuccess=@"0";//0表示未发出不成功的通知，1表示已发出不成功的通知
        
        if (resp.errCode == -2) {
            //发出支付取消通知
            [[NSNotificationCenter defaultCenter]postNotificationName:KPayCancel object:nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:KPayNoSuccess object:nil];
            noSuccess=@"1";
        }
        
        DDUserManager *userManager=[DDUserManager sharedInstance];
        
        NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
        [params setValue:userManager.payOrderId forKey:@"payOrderId"];
        
        [[DDHttpManager sharedInstance]sendGetRequest:KHttpRequest_judgePaySuccess params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
            NSLog(@"***********判断是否支付成功***************%@",responseObject);
            
            DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
            if (response.isSuccess) {

                if ([responseObject[KCode] isEqual:@0]) {
                    //支付成功
                    //发出支付成功通知
                    [[NSNotificationCenter defaultCenter]postNotificationName:KPaySuccessful object:nil];
                }
                else{
                    //发出支付失败通知
                    [[NSNotificationCenter defaultCenter] postNotificationName:KPayNoSuccess object:nil];
                }
                
            }
            else{
                //发出支付失败通知
//                [[NSNotificationCenter defaultCenter] postNotificationName:KPayFail object:nil];
                //[DDUtils showToastWithMessage:response.message];
                if ([noSuccess isEqualToString:@"0"]) {
                    [[NSNotificationCenter defaultCenter]postNotificationName:KPayNoSuccess object:nil];
                }
            }
            
            
        } failure:^(NSURLSessionDataTask *operation, id responseObject) {
            [DDUtils showToastWithMessage:kRequestFailed];
        }];
        
        
        //支付返回结果，实际支付结果需要去微信服务器端查询
//        NSString *strMsg,*strTitle = [NSString stringWithFormat:@"支付结果"];
//
//        switch (resp.errCode) {
//            case WXSuccess:
//                strMsg = @"支付结果：成功！";
//                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
//                break;
//
//            default:
//                //strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
//                strMsg =@"支付结果：失败！";
//                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
//                break;
//        }
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
//    }else {
    }
}

- (void)onReq:(BaseReq *)req {

}

@end
