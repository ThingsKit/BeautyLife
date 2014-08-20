//
//  AppDelegate.m
//  BeautyLife
//
//  Created by Seven on 14-7-28.
//  Copyright (c) 2014年 Seven. All rights reserved.
//
#import "AppDelegate.h"
#import "AlixPayResult.h"
#import "DataVerifier.h"

BMKMapManager* _mapManager;

@implementation AppDelegate
@synthesize mainPage;
@synthesize stewardPage;
@synthesize lifePage;
@synthesize settingPage;
@synthesize tabBarController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //检查网络是否存在 如果不存在 则弹出提示
    [UserModel Instance].isNetworkRunning = [CheckNetwork isExistenceNetwork];
    //显示系统托盘
    [application setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    //获取并保存用户信息
    [self saveUserInfo];
    //首页
    self.mainPage = [[MainPageView alloc] initWithNibName:@"MainPageView" bundle:nil];
    mainPage.tabBarItem.image = [UIImage imageNamed:@"tab_main"];
    mainPage.tabBarItem.title = @"首页";
    UINavigationController *mainPageNav = [[UINavigationController alloc] initWithRootViewController:self.mainPage];
    //精管家
    self.stewardPage = [[StewardPageView alloc] initWithNibName:@"StewardPageView" bundle:nil];
    stewardPage.tabBarItem.image = [UIImage imageNamed:@"tab_steward"];
    stewardPage.tabBarItem.title = @"金管家";
    UINavigationController *stewardPageNav = [[UINavigationController alloc] initWithRootViewController:self.stewardPage];
    //精管家
    self.lifePage = [[LifePageView alloc] initWithNibName:@"LifePageView" bundle:nil];
    lifePage.tabBarItem.image = [UIImage imageNamed:@"tab_life"];
    lifePage.tabBarItem.title = @"美生活";
    UINavigationController *lifePageNav = [[UINavigationController alloc] initWithRootViewController:self.lifePage];
    //我
    self.settingPage = [[SettingView alloc] initWithNibName:@"SettingView" bundle:nil];
    settingPage.tabBarItem.image = [UIImage imageNamed:@"tab_my"];
    settingPage.tabBarItem.title = @"我";
    UINavigationController *settingPageNav = [[UINavigationController alloc] initWithRootViewController:self.settingPage];
    
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:
                                             mainPageNav,
                                             stewardPageNav,
                                             lifePageNav,
                                             settingPageNav,
                                             nil];
    [[self.tabBarController tabBar] setSelectedImageTintColor:[UIColor colorWithRed:246.0/255 green:129.0/255 blue:33.0/255 alpha:1.0]];
    //设置UINavigationController背景
    if (IS_IOS7) {
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"top_bg7"]  forBarMetrics:UIBarMetricsDefault];
    }
    else
    {
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"top_bg"]  forBarMetrics:UIBarMetricsDefault];
        [[self.tabBarController tabBar] setBackgroundImage:[UIImage imageNamed:@"tabbar_bg"]];
    }
    
    // 要使用百度地图，请先启动BaiduMapManager
	_mapManager = [[BMKMapManager alloc]init];
	BOOL ret = [_mapManager start:@"mHvrWc0BMGNrMAjqGhGQvNpr" generalDelegate:self];
	if (!ret) {
		NSLog(@"manager start failed!");
	}
    //设置目录不进行IOS自动同步！否则审核不能通过
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *directory = [NSString stringWithFormat:@"%@/cfg", [paths objectAtIndex:0]];
    NSURL *dbURLPath = [NSURL fileURLWithPath:directory];
    [self addSkipBackupAttributeToItemAtURL:dbURLPath];
    [self addSkipBackupAttributeToPath:directory];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setRootViewController:self.tabBarController ];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)saveUserInfo
{
    UserModel *usermodel = [UserModel Instance];
    if ([usermodel isLogin]) {
        NSString *userinfoUrl = [NSString stringWithFormat:@"%@%@?APPKey=%@&tel=%@", api_base_url, api_getuserinfo, appkey, [usermodel getUserValueForKey:@"tel"]];
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:userinfoUrl]];
        [request setDelegate:self];
        [request setDidFailSelector:@selector(requestFailed:)];
        [request setDidFinishSelector:@selector(requestUserinfo:)];
        [request startAsynchronous];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{

}
- (void)requestUserinfo:(ASIHTTPRequest *)request
{
    [request setUseCookiePersistence:YES];
    NSData *data = [request.responseString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (!json) {
        return;
    }
    User *user = [Tool readJsonStrToUser:request.responseString];
    int userid = [user.id intValue];
    if (userid > 0) {
        //设置登录并保存用户信息
        UserModel *userModel = [UserModel Instance];
        [userModel saveIsLogin:YES];
        [userModel saveValue:user.id ForKey:@"id"];
        [userModel saveValue:user.cid ForKey:@"cid"];
        [userModel saveValue:user.build_id ForKey:@"build_id"];
        [userModel saveValue:user.house_number ForKey:@"house_number"];
        [userModel saveValue:user.carport_number ForKey:@"carport_number"];
        [userModel saveValue:user.name ForKey:@"name"];
        [userModel saveValue:user.nickname ForKey:@"nickname"];
        [userModel saveValue:user.address ForKey:@"address"];
        [userModel saveValue:user.tel ForKey:@"tel"];
        [userModel saveValue:user.pwd ForKey:@"pwd"];
        [userModel saveValue:user.avatar ForKey:@"avatar"];
        [userModel saveValue:user.email ForKey:@"email"];
        [userModel saveValue:user.card_id ForKey:@"card_id"];
        [userModel saveValue:user.property ForKey:@"property"];
        [userModel saveValue:user.plate_number ForKey:@"plate_number"];
        [userModel saveValue:user.credits ForKey:@"credits"];
        [userModel saveValue:user.remark ForKey:@"remark"];
        [userModel saveValue:user.checkin ForKey:@"checkin"];
    }
}

- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    
    NSError *error = nil;
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
    if(!success){
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    return success;
}

- (void)addSkipBackupAttributeToPath:(NSString*)path {
    u_int8_t b = 1;
    setxattr([path fileSystemRepresentation], "com.apple.MobileBackup", &b, 1, 0, 0);
}


//独立客户端回调函数
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    NSString * query = [[url query] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"uoe:%@",query);
	[self parse:url application:application];
	return YES;
}

- (void)parse:(NSURL *)url application:(UIApplication *)application {
    
    //结果处理
    AlixPayResult* result = [self handleOpenURL:url];
    
	if (result)
    {
		
		if (result.statusCode == 9000)
        {
			/*
			 *用公钥验证签名 严格验证请使用result.resultString与result.signString验签
			 */
            
            //交易成功
            //            NSString* key = @"签约帐户后获取到的支付宝公钥";
            //			id<DataVerifier> verifier;
            //            verifier = CreateRSADataVerifier(key);
            //
            //			if ([verifier verifyString:result.resultString withSign:result.signString])
            //            {
            //                //验证签名成功，交易结果无篡改
            //			}
            
        }
        else
        {
            //交易失败
        }
    }
    else
    {
        //失败
    }
    
}

- (AlixPayResult *)resultFromURL:(NSURL *)url {
	NSString * query = [[url query] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
#if ! __has_feature(objc_arc)
    return [[[AlixPayResult alloc] initWithString:query] autorelease];
#else
	return [[AlixPayResult alloc] initWithString:query];
#endif
}

- (AlixPayResult *)handleOpenURL:(NSURL *)url {
	AlixPayResult * result = nil;
	
	if (url != nil && [[url host] compare:@"safepay"] == 0) {
		result = [self resultFromURL:url];
	}
    
	return result;
}

@end
