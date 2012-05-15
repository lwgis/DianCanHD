//
//  CategoryImage.h
//  DianCanHD
//
//  Created by 赵飞 on 12-5-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Category;

@interface CategoryImage : NSManagedObject

@property (nonatomic, retain) id image;
@property (nonatomic, retain) Category *category;

@end
