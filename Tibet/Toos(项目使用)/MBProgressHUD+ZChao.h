//
//  MBProgressHUD+ZChao.h
//  HtmlLoad
//
//  Created by zchao on 2019/3/29.
//  Copyright © 2019 zchao. All rights reserved.
//

#import "MBProgressHUD.h"

NS_ASSUME_NONNULL_BEGIN

@interface MBProgressHUD (ZChao)

/**
 中间显示

 @param text 显示内容
 */
+ (void)showText:(nullable NSString *)text;


/**
 顶部显示

 @param text 显示内容
 */
+ (void)showTopText:(nullable NSString *)text;


/**
 底部显示

 @param text 显示内容
 */
+ (void)showBottomText:(nullable NSString *)text;


#pragma mark - detailText


/**
 中间显示，多行显示

 @param text 显示内容
 */
+ (void)showDetailText:(NSString *)text;

/**
 顶部显示，多行显示
 
 @param text 显示内容
 */
+ (void)showTopDetailText:(NSString *)text;

/**
 底部显示，多行显示
 
 @param text 显示内容
 */
+ (void)showBottomDetailText:(NSString *)text;

#pragma mark - Activity
/**
 Activity + text
 在window上 text为nil或@"" 只显示 Activity
 @param text 显示内容
 */
+ (void)showActivityText:(nullable NSString *)text;



/**
 Activity + text
 在window上 text为nil或@"" 只显示 Activity

 @param text text
 @param view superView
 */
+ (void)showActivityText:(nullable NSString *)text inView:(UIView *)view;


+ (instancetype)showHudMode:(MBProgressHUDMode)model text:(nullable NSString *)text;

/**
 对号 + text
 在window上 text为nil或@"" 只显示 对号
 
 @param text text
 */
+ (void)showCheckMarkWithText:(nullable NSString *)text;

+ (void)hideHud;

+ (void)hideAnimated:(BOOL)animated;


+ (void)hideAnimated:(BOOL)animated After:(NSTimeInterval)after;
@end

NS_ASSUME_NONNULL_END
