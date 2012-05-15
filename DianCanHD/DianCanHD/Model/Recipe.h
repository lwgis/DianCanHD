//
//  Recipe.h
//  DianCanHD
//
//  Created by 赵飞 on 12-5-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Category, RecipeImage;

@interface Recipe : NSManagedObject

@property (nonatomic, retain) NSNumber * cID;
@property (nonatomic, retain) NSString * rDescription;
@property (nonatomic, retain) NSNumber * rID;
@property (nonatomic, retain) NSString * rImageURL;
@property (nonatomic, retain) NSString * rName;
@property (nonatomic, retain) NSNumber * rPrice;
@property (nonatomic, retain) Category *category;
@property (nonatomic, retain) RecipeImage *image;

@end
