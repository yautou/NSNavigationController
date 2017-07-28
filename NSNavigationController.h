//
//  NSNavigationController.h
//  The missing UINavigationController for macOS.
//
//  Created by Qeye Wang on 15/06/2017.
//  Copyright © 2017 Qeye Wang. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class NSNavigationController;
@interface NSViewController (Navigation)
@property(nullable, nonatomic,readonly,strong) NSNavigationController *navigationController;
@end

@interface NSNavigationController : NSViewController
@property (nonatomic, strong)NSViewController * _Nonnull rootViewController;

- (instancetype _Nonnull )initWithRootViewController:(NSViewController *_Nonnull)rootViewController;

- (void)pushViewController:(NSViewController *_Nonnull)viewController animated:(BOOL)animated;
- (nullable NSViewController *)popViewControllerAnimated:(BOOL)animated;
- (nullable NSArray<__kindof NSViewController *> *)popToRootViewControllerAnimated:(BOOL)animated;

@property(nullable, nonatomic,readonly,strong) NSViewController *topViewController;
@property(nullable, nonatomic,copy) NSArray<__kindof NSViewController *> *viewControllers;
@end
