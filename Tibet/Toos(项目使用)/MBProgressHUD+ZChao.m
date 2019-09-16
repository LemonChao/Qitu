//
//  MBProgressHUD+ZChao.m
//  HtmlLoad
//
//  Created by zchao on 2019/3/29.
//  Copyright © 2019 zchao. All rights reserved.
//

#import "MBProgressHUD+ZChao.h"

static MBProgressHUD *sharedHud;
static CGFloat duration = 2.f;
@implementation MBProgressHUD (ZChao)


+ (MBProgressHUD *)createMBProgressHUDWithView:(UIView *)view {
//    MBProgressHUD *originHud;
//    UIWindow *window = [UIApplication sharedApplication].delegate.window;
//    if (![view isKindOfClass:[UIWindow class]]) { //将要显示view上，先到window上找
//        originHud = [MBProgressHUD HUDForView:window];
//    }else { //将要显示在window上 先到view上找
//        originHud = [MBProgressHUD HUDForView:[self getCurrentUIVC].view];
//    }
//
//    if (originHud) {// 在另一个地方找到了
//        [originHud hideAnimated:NO];
//    }
//
//    //再到自己这里找
//    MBProgressHUD *hud = [MBProgressHUD HUDForView:view];
//    if (!hud) {
//        hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
//        hud.removeFromSuperViewOnHide = YES;
//    }

//    MBProgressHUD *hud = [MBProgressHUD HUDForView:view];
    //hud 存在，且父视图相同
    if (sharedHud && view == sharedHud.superview) return sharedHud;

    //如果存在，父视图不同，要先停止之前的hud，不存在没有任何影响
    [sharedHud hideAnimated:NO];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.removeFromSuperViewOnHide = YES;
    sharedHud = hud;
    hud.completionBlock = ^{
        sharedHud = nil;
    };


    return hud;
}

+ (MBProgressHUD *)createMBProgressHUD {
    UIView *view = [UIApplication sharedApplication].delegate.window;
    return [self createMBProgressHUDWithView:view];
}


+ (void)showText:(NSString *)text offsetY:(CGFloat)offsetY time:(NSTimeInterval)time {
    MBProgressHUD *hud = [self createMBProgressHUD];
    hud.mode = MBProgressHUDModeText;

    hud.label.text = text;
    hud.offset = CGPointMake(0, offsetY);
//    hud.label.textColor = [UIColor whiteColor];
//    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
//    hud.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:0.8];

    [hud hideAnimated:YES afterDelay:time];
}

+ (void)showText:(NSString *)text {
    [self showText:text offsetY:0 time:2.f];
}

+ (void)showTopText:(NSString *)text {
    [self showText:text offsetY:-MBProgressMaxOffset time:duration];
}

+ (void)showBottomText:(NSString *)text {
    [self showText:text offsetY:MBProgressMaxOffset time:duration];
}

#pragma mark - detailsText
+ (void)showDetailText:(NSString *)text offsetY:(CGFloat)offsetY time:(NSTimeInterval)time {
    MBProgressHUD *hud = [self createMBProgressHUD];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = nil;
    hud.detailsLabel.text = text;
    hud.detailsLabel.font = [UIFont systemFontOfSize:14];
    hud.offset = CGPointMake(0, offsetY);
//    hud.detailsLabel.textColor = [UIColor whiteColor];
//    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
//    hud.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    
    [hud hideAnimated:YES afterDelay:time];
}

+ (void)showDetailText:(NSString *)text {
    [self showDetailText:text offsetY:0 time:duration];
}

+ (void)showTopDetailText:(NSString *)text {
    [self showDetailText:text offsetY:-MBProgressMaxOffset time:duration];
}

+ (void)showBottomDetailText:(NSString *)text {
    [self showDetailText:text offsetY:MBProgressMaxOffset time:duration];
}


#pragma mark - Activity

+ (void)showActivityText:(NSString *)text {
    MBProgressHUD *hud = [self showHudMode:MBProgressHUDModeIndeterminate text:text];
    hud.graceTime = 3.f;
//    hud.minShowTime = 2.f;
}

+ (void)showActivityText:(NSString *)text inView:(UIView *)view {
    MBProgressHUD *hud = [self createMBProgressHUDWithView:view];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = text;
}

+ (instancetype)showHudMode:(MBProgressHUDMode)model text:(NSString *)text {
    MBProgressHUD *hud = [self createMBProgressHUD];
    hud.mode = model;
    hud.label.text = text;
    
    return hud;
}

+ (void)showCheckMarkWithText:(nullable NSString *)text {
    MBProgressHUD *hud = [self showHudMode:MBProgressHUDModeCustomView text:text];
    UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    hud.customView = [[UIImageView alloc] initWithImage:image];
    // Looks a bit nicer if we make it square.
    hud.square = YES;
    // Optional label text.
    hud.label.text = text;
    
    [hud hideAnimated:YES afterDelay:2.f];
}

+ (void)hideHud {
    [sharedHud hideAnimated:YES];
}

+ (void)hideAnimated:(BOOL)animated {
    [sharedHud hideAnimated:animated];
}

+ (void)hideAnimated:(BOOL)animated After:(NSTimeInterval)after {
    [sharedHud hideAnimated:animated afterDelay:after];

}


#pragma mark --- 获取当前Window试图---------
//获取当前屏幕显示的viewcontroller
+(UIViewController*)getCurrentWindowVC
{
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    //app默认windowLevel是UIWindowLevelNormal，如果不是，找到它
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    id nextResponder = nil;
    UIViewController *appRootVC = window.rootViewController;
    //1、通过present弹出VC，appRootVC.presentedViewController不为nil
    if (appRootVC.presentedViewController) {
        nextResponder = appRootVC.presentedViewController;
    }else{
        //2、通过navigationcontroller弹出VC
        //        NSLog(@"subviews == %@",[window subviews]);
        UIView *frontView = [[window subviews] objectAtIndex:0];
        nextResponder = [frontView nextResponder];
    }
    return nextResponder;
}

+(UINavigationController*)getCurrentNaVC
{
    
    UIViewController  *viewVC = (UIViewController*)[ self getCurrentWindowVC ];
    UINavigationController  *naVC;
    if ([viewVC isKindOfClass:[UITabBarController class]]) {
        UITabBarController  *tabbar = (UITabBarController*)viewVC;
        naVC = (UINavigationController *)tabbar.viewControllers[tabbar.selectedIndex];
        if (naVC.presentedViewController) {
            while (naVC.presentedViewController) {
                naVC = (UINavigationController*)naVC.presentedViewController;
            }
        }
    }else
        if ([viewVC isKindOfClass:[UINavigationController class]]) {
            
            naVC  = (UINavigationController*)viewVC;
            if (naVC.presentedViewController) {
                while (naVC.presentedViewController) {
                    naVC = (UINavigationController*)naVC.presentedViewController;
                }
            }
        }else
            if ([viewVC isKindOfClass:[UIViewController class]])
            {
                if (viewVC.navigationController) {
                    return viewVC.navigationController;
                }
                return  (UINavigationController*)viewVC;
            }
    return naVC;
}

+(UIViewController*)getCurrentUIVC
{
    UIViewController   *cc;
    UINavigationController  *na = (UINavigationController*)[[self class] getCurrentNaVC];
    if ([na isKindOfClass:[UINavigationController class]]) {
        cc =  na.viewControllers.lastObject;
        
        if (cc.childViewControllers.count>0) {
            
            cc = [[self class] getSubUIVCWithVC:cc];
        }
    }else
    {
        cc = (UIViewController*)na;
    }
    return cc;
}
+(UIViewController *)getSubUIVCWithVC:(UIViewController*)vc
{
    UIViewController   *cc;
    cc =  vc.childViewControllers.lastObject;
    if (cc.childViewControllers>0) {
        
        [[self class] getSubUIVCWithVC:cc];
    }else
    {
        return cc;
    }
    return cc;
}

@end
