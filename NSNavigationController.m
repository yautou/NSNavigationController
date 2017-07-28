//
//  NSNavigationController.m
//  The missing UINavigationController for macOS.
//
//  Created by Qeye Wang on 15/06/2017.
//  Copyright © 2017 Qeye Wang. All rights reserved.
//

#import "NSNavigationController.h"
#import <objc/runtime.h>

static const NSString *kNavgationControllerKey = @"kNavgationControllerKey";
@implementation NSViewController (Navigation)

- (NSNavigationController *)navigationController {
    id nav = objc_getAssociatedObject(self, &kNavgationControllerKey);
    return nav;
}

- (void)setNavigationController:(NSNavigationController * _Nullable)navigationController {
    objc_setAssociatedObject(self, &kNavgationControllerKey, navigationController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@interface NSNavigationController ()
@property(nullable, nonatomic,readwrite,strong) NSViewController *topViewController;
@end

@implementation NSNavigationController

- (instancetype _Nonnull )initWithRootViewController:(NSViewController *_Nonnull)rootViewController {
    NSAssert(rootViewController, @"root view can't be nil");
    if (self = [super initWithNibName:NSStringFromClass(NSNavigationController.class) bundle:nil]) {
        _rootViewController = rootViewController;
        _rootViewController.navigationController = self;
        [self addChildViewController:_rootViewController];
        [self.view addSubview:_rootViewController.view];
        _topViewController = _rootViewController;
    }
    return self;
}

- (void)pushViewController:(NSViewController *_Nonnull)viewController animated:(BOOL)animated {
    [self addChildViewController:viewController];
    [viewController setNavigationController:self];
    [self transitionFromViewController:self.topViewController
                      toViewController:viewController
                               options:animated ? NSViewControllerTransitionSlideLeft : NSViewControllerTransitionNone
                     completionHandler:^{
                         self.topViewController = viewController;
                     }];
    
}

- (nullable NSViewController *)popViewControllerAnimated:(BOOL)animated {
    NSArray *vcs = self.childViewControllers;
    if (vcs.count < 2) return nil;
    NSViewController *vc = vcs[vcs.count - 2];
    [self transitionFromViewController:self.topViewController
                      toViewController:vc
                               options:animated ? NSViewControllerTransitionSlideRight :  NSViewControllerTransitionNone
                     completionHandler:^{
                         [self.topViewController removeFromParentViewController];
                         self.topViewController = vc;
                     }];
    return self.topViewController;
}

- (nullable NSArray<__kindof NSViewController *> *)popToRootViewControllerAnimated:(BOOL)animated {
    [self transitionFromViewController:self.topViewController
                      toViewController:self.rootViewController
                               options:animated ? NSViewControllerTransitionSlideRight :  NSViewControllerTransitionNone
                     completionHandler:^{
                         for (int index = 1; index < self.childViewControllers.count; index++) {
                             NSViewController *vc = self.childViewControllers[index];
                             [vc removeFromParentViewController];
                         }
                         self.topViewController = self.rootViewController;
                     }];
    
    NSMutableArray *vcs = [NSMutableArray array];
    for (int index = 1; index < self.childViewControllers.count; index++) {
        NSViewController *vc = self.childViewControllers[index];
        [vcs addObject:vc];
    }
    return vcs;
}

- (NSArray<NSViewController *> *)viewControllers {
    return self.childViewControllers;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

@end
