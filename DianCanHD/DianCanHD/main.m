//
//  main.m
//  DianCanHD
//
//  Created by 李炜 on 12-5-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZTAppDelegate.h"

int main(int argc, char *argv[])
{
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    int retVal =UIApplicationMain(argc, argv, nil, NSStringFromClass([ZTAppDelegate class]));
     [pool release];
    return retVal;
}
