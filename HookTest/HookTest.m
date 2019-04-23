//
//  HookTest.m
//  HookTest
//
//  Created by subdiox on 2019/04/24.
//  Copyright © 2019 subdiox. All rights reserved.
//

#import "HookTest.h"
@import ObjectiveC.runtime;
@import AppKit;

@implementation HookTest

+ (void)load {
    Class hookClass = NSClassFromString(@"HookTest");
    SEL hookSelector = NSSelectorFromString(@"hookInit");
    Method hookMethod = class_getInstanceMethod(hookClass, hookSelector);
    IMP hookImplementation = method_getImplementation(hookMethod);

    Class targetClass = NSClassFromString(@"iTermController");
    SEL targetSelector = NSSelectorFromString(@"init");
    Method targetMethod = class_getInstanceMethod(targetClass, targetSelector);
    IMP targetImplementation = method_getImplementation(targetMethod);
    const char* targetTypeEncoding = method_getTypeEncoding(targetMethod);
    
    SEL originalStoredSelector = NSSelectorFromString(@"originalInit");
    class_addMethod(targetClass, originalStoredSelector, targetImplementation, targetTypeEncoding);
    class_replaceMethod(targetClass, targetSelector, hookImplementation, targetTypeEncoding);
}

- (id)hookInit {
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:@"フック成功！"];
    [alert addButtonWithTitle:@"OK"];
    [alert runModal];
    return [self originalInit];
}

- (id)originalInit {
    return nil;
}

@end
