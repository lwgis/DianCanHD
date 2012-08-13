//
//  RestEngine.h
//  testCoreData
//
//  Created by 赵飞 on 12-3-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIImage;

#define REQUEST_HOST @"HTTP://192.168.1.102:8080"

#define ALL_CATEGORY_URL [NSString stringWithFormat:@"%@/ChihuoService/rest/categories/",REQUEST_HOST]
#define RECIPE_BY_CATEGORY_URL(__ID__) [NSString stringWithFormat:@"%@/ChihuoService/rest/categories/%i",REQUEST_HOST, __ID__]

#define ALL_DESKTYPES_URL [NSString stringWithFormat:@"%@/ChihuoService/rest/desktypes/",REQUEST_HOST]
#define DESK_BY_TYPE_URL(__ID__) [NSString stringWithFormat:@"%@/ChihuoService/rest/desktypes/%i",REQUEST_HOST, __ID__]
#define ALL_DESK_URL [NSString stringWithFormat:@"%@/ChihuoService/rest/desks/",REQUEST_HOST]

#define SUBMIT_ORDER_URL @"/ChihuoService/rest/orders/"
#define ORDER_DETAIL_URL(__ID__) [NSString stringWithFormat:@"%@/ChihuoService/rest/orders/%i",REQUEST_HOST, __ID__]

#define ALL_DOMAIN_URL [NSString stringWithFormat:@"%@/ChihuoService/rest/all/",REQUEST_HOST]

#define IMAGE_URL(__URL__) [NSString stringWithFormat:@"http://192.168.1.102:8080/ChihuoService/MenuImages/%@", __URL__]


        
@interface RestEngine : NSObject

@property(nonatomic, strong)NSManagedObjectContext *managedObjectContext;

typedef void (^ErrorBlock)(NSError *error);

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

//获取所有离线数据
- (void) getAllDomainOnCompletion:(void (^)(NSDictionary *dictionary)) completeBlock onError:(ErrorBlock) errorBlock;


// 下载图片
- (void) getImage:(NSString*)url OnCompletion:(void (^)(UIImage *image)) completeBlock onError:(ErrorBlock) errorBlock;


@end
