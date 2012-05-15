//
//  RestEngine.m
//  testCoreData
//
//  Created by 赵飞 on 12-3-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RestEngine.h"

#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "AFJSONRequestOperation.h"
#import "AFImageRequestOperation.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "AFJSONUtilities.h"
#import "SDURLCache.h"

#import "Category.h"
#import "Category+Search.h"
#import "CategoryImage.h"
#import "Recipe.h"
#import "Recipe+Search.h"
#import "RecipeImage.h"
#import "Desk.h"
#import "Desk+Search.h"
#import "DeskType.h"
#import "DeskType+Search.h"
#import "UpdateRecord.h"
#import "UpdateRecord+Search.h"

@interface RestEngine() 
- (void) saveAddCategoryList:(NSDictionary*) json;
- (void) saveUpdateCategoryList:(NSDictionary*) json;
- (void) saveDeleteCategoryList:(NSDictionary*) json;

- (void) saveAddRecipeList:(NSDictionary*) json;
- (void) saveUpdateRecipeList:(NSDictionary*) json;
- (void) saveDeleteRecipeList:(NSDictionary*) json;

- (void) saveAddDeskList:(NSDictionary*) json;
- (void) saveUpdateDeskList:(NSDictionary*) json;
- (void) saveDeleteDeskList:(NSDictionary*) json;

- (void) saveAddDeskTypeList:(NSDictionary*) json;
- (void) saveUpdateDeskTypeList:(NSDictionary*) json;
- (void) saveDeleteDeskTypeList:(NSDictionary*) json;

- (void) updateDate:(NSString *) updateDateStr;
@end


@implementation RestEngine

@synthesize managedObjectContext = _managedObjectContext;

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    self = [super init];
    if(self){
        _managedObjectContext = managedObjectContext;
        
        //自定义缓存
        SDURLCache *urlCache = [[SDURLCache alloc] initWithMemoryCapacity:1024*1024*5
            diskCapacity:1024*1024*80
            diskPath:[SDURLCache defaultCachePath]];
        [NSURLCache setSharedURLCache:urlCache];
        
        //显示菊花
        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    }
    return self;
}

- (void)getAllDomainOnCompletion:(void (^)(NSDictionary *))completeBlock onError:(ErrorBlock)errorBlock
{
    NSURL *url = [NSURL URLWithString:ALL_DOMAIN_URL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
    NSLog(@"%@", JSON);

    [self saveAddCategoryList:[JSON objectForKey:@"addCategories"]];
    [self saveUpdateCategoryList:[JSON objectForKey:@"updateCategories"]];
    [self saveDeleteCategoryList:[JSON objectForKey:@"deleteCategories"]];
        
    [self saveAddRecipeList:[JSON objectForKey:@"addRecipes"]];
    [self saveUpdateRecipeList:[JSON objectForKey:@"updateRecipes"]];
    [self saveDeleteRecipeList:[JSON objectForKey:@"deleteRecipes"]];
        
    [self saveAddDeskTypeList:[JSON objectForKey:@"addDeskTypes"]];
    [self saveUpdateDeskTypeList:[JSON objectForKey:@"updateDeskTypes"]];
    [self saveDeleteDeskTypeList:[JSON objectForKey:@"deleteDeskTypes"]];
        
    [self saveAddDeskList:[JSON objectForKey:@"addDesks"]];
    [self saveUpdateDeskList:[JSON objectForKey:@"updateDesks"]];
    [self saveDeleteDeskList:[JSON objectForKey:@"deleteDesks"]];
        
    [self updateDate:[JSON objectForKey:@"date"]];
//        completeBlock(array); 
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
        errorBlock(error);
    }];
    
    [operation start];
}

- (void) getImage:(NSString *)urlStr OnCompletion:(void (^)(UIImage *image))completeBlock onError:(ErrorBlock)errorBlock
{
    NSURL *url = [NSURL URLWithString:IMAGE_URL(urlStr)];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60];
    
    AFImageRequestOperation *operation = [AFImageRequestOperation imageRequestOperationWithRequest:request success:^(UIImage *image) {
        completeBlock(image);
    }];
    
    [operation start];
}

//新增种类
- (void)saveAddCategoryList:(NSDictionary *)json
{
    for (NSDictionary* dic in json) {
        Category *oc = [Category categoryWithID:[[dic objectForKey:@"id"] integerValue] inManagedObjectContext:self.managedObjectContext];
        if (oc) {
            [self.managedObjectContext deleteObject:oc];
        }
        Category *c = (Category *)[NSEntityDescription insertNewObjectForEntityForName:@"Category" inManagedObjectContext:self.managedObjectContext];
        
        [c setCID:[NSNumber numberWithInteger:[[dic objectForKey:@"id"] integerValue]]];
        [c setCName:[dic objectForKey:@"name"]];
        [c setCDescription:[dic objectForKey:@"description"]];
        [c setCImageURL:[dic objectForKey:@"image"]];
    }
    NSError *serror;
    if (![self.managedObjectContext save:&serror]) {
    }
    
    //获取种类的图片
    for (NSDictionary* dic in json) {
        [self getImage:[dic objectForKey:@"image"] OnCompletion:^(UIImage *image) {
            Category *category = [Category categoryWithID:[[dic objectForKey:@"id"] integerValue] inManagedObjectContext:self.managedObjectContext];
            
            CategoryImage *categoryImage = (CategoryImage *)[NSEntityDescription insertNewObjectForEntityForName:@"CategoryImage" inManagedObjectContext:self.managedObjectContext];
            [categoryImage setImage:image];
            [category setImage:categoryImage];
            NSError *serror;
            if (![self.managedObjectContext save:&serror]) {
            }
        } onError:^(NSError *error) {
            
        }];
    }
}

//修改种类
- (void)saveUpdateCategoryList:(NSDictionary *)json
{
    for (NSDictionary* dic in json) {
        Category *c = [Category categoryWithID:[[dic objectForKey:@"id"] integerValue] inManagedObjectContext:self.managedObjectContext];
        if (c) {
            [c setCID:[NSNumber numberWithInteger:[[dic objectForKey:@"id"] integerValue]]];
            [c setCName:[dic objectForKey:@"name"]];
            [c setCDescription:[dic objectForKey:@"description"]];
            [c setCImageURL:[dic objectForKey:@"image"]];
        }
    }
    NSError *serror;
    if (![self.managedObjectContext save:&serror]) {
    }
    
    //获取种类的图片
    for (NSDictionary* dic in json) {
        [self getImage:[dic objectForKey:@"image"] OnCompletion:^(UIImage *image) {
            Category *category = [Category categoryWithID:[[dic objectForKey:@"id"] integerValue] inManagedObjectContext:self.managedObjectContext];
            
            CategoryImage *categoryImage = (CategoryImage *)[NSEntityDescription insertNewObjectForEntityForName:@"CategoryImage" inManagedObjectContext:self.managedObjectContext];
            [categoryImage setImage:image];
            [category setImage:categoryImage];
            NSError *serror;
            if (![self.managedObjectContext save:&serror]) {
            }
        } onError:^(NSError *error) {
            
        }];
    }
}

//删除种类
- (void)saveDeleteCategoryList:(NSDictionary *)json
{
    for (NSNumber* cid in json) {
        Category *c = [Category categoryWithID:[cid integerValue] inManagedObjectContext:self.managedObjectContext];
        if (c) {
            [self.managedObjectContext deleteObject:c];
        }
    }
    
    NSError *serror;
    if (![self.managedObjectContext save:&serror]) {
    }
}

//新增菜单
- (void)saveAddRecipeList:(NSDictionary *)json
{
    for (NSDictionary* dic in json) {
        Recipe *oc = [Recipe recipeWithID:[[dic objectForKey:@"id"] integerValue] inManagedObjectContext:self.managedObjectContext];
        if (oc) {
            [self.managedObjectContext deleteObject:oc];
        }
        
        Recipe *recipe = (Recipe *)[NSEntityDescription insertNewObjectForEntityForName:@"Recipe" inManagedObjectContext:self.managedObjectContext];
        
        [recipe setRID:[NSNumber numberWithInteger:[[dic objectForKey:@"id"] integerValue]]];
        [recipe setRName:[dic objectForKey:@"name"]];
        [recipe setRPrice:[NSNumber numberWithDouble:[[dic objectForKey:@"price"] doubleValue]]];
        [recipe setRImageURL:[dic objectForKey:@"image"]];
        [recipe setCID:[NSNumber numberWithInteger:[[dic objectForKey:@"cid"] integerValue]]];
        [recipe setRDescription:[dic objectForKey:@"description"]];
        
        //获取菜的种类
        NSArray * array = recipe.fetchedCategory;
        if(array.count > 0){
            Category *category = (Category*) [array lastObject];
            [recipe setCategory:category];
        }
    }
    
    NSError *serror;
    if (![self.managedObjectContext save:&serror]) {
    }
    
    for (NSDictionary* dic in json) {
        [self getImage:[dic objectForKey:@"image"] OnCompletion:^(UIImage *image) {
            Recipe *recipe = [Recipe recipeWithID:[[dic objectForKey:@"id"] integerValue] inManagedObjectContext:self.managedObjectContext];
            RecipeImage *recipeImage = (RecipeImage *)[NSEntityDescription insertNewObjectForEntityForName:@"RecipeImage" inManagedObjectContext:self.managedObjectContext];
            [recipeImage setImage:image];
            [recipe setImage:recipeImage];
            NSError *serror;
            if (![self.managedObjectContext save:&serror]) {
            }
        } onError:^(NSError *error) {
            
        }];
    }
}

//更新菜单
- (void)saveUpdateRecipeList:(NSDictionary *)json
{
    for (NSDictionary* dic in json) {
        Recipe *recipe = [Recipe recipeWithID:[[dic objectForKey:@"id"] integerValue] inManagedObjectContext:self.managedObjectContext];
        if (recipe) {        
            [recipe setRID:[NSNumber numberWithInteger:[[dic objectForKey:@"id"] integerValue]]];
            [recipe setRName:[dic objectForKey:@"name"]];
            [recipe setRPrice:[NSNumber numberWithDouble:[[dic objectForKey:@"price"] doubleValue]]];
            [recipe setRImageURL:[dic objectForKey:@"image"]];
            [recipe setCID:[NSNumber numberWithInteger:[[dic objectForKey:@"cid"] integerValue]]];
            [recipe setRDescription:[dic objectForKey:@"description"]];
            
            //获取菜的种类
            NSArray * array = recipe.fetchedCategory;
            if(array.count > 0){
                Category *category = (Category*) [array lastObject];
                [recipe setCategory:category];
            }
        }
    }
    NSError *serror;
    if (![self.managedObjectContext save:&serror]) {
    }
    
    for (NSDictionary* dic in json) {
        //获取菜的图片
        [self getImage:[dic objectForKey:@"image"] OnCompletion:^(UIImage *image) {
            Recipe *recipe = [Recipe recipeWithID:[[dic objectForKey:@"id"] integerValue] inManagedObjectContext:self.managedObjectContext];
            
            RecipeImage *recipeImage = (RecipeImage *)[NSEntityDescription insertNewObjectForEntityForName:@"RecipeImage" inManagedObjectContext:self.managedObjectContext];
            [recipeImage setImage:image];
            [recipe setImage:recipeImage];
            NSError *serror;
            if (![self.managedObjectContext save:&serror]) {
            }
        } onError:^(NSError *error) {
            
        }];
    }
}

//删除菜单
- (void)saveDeleteRecipeList:(NSDictionary *)json
{
    for (NSNumber* cid in json) {
        Recipe *c = [Recipe recipeWithID:[cid integerValue] inManagedObjectContext:self.managedObjectContext];
        if (c) {
            [self.managedObjectContext deleteObject:c];
        }
    }
    NSError *serror;
    if (![self.managedObjectContext save:&serror]) {
    }
}

- (void)saveAddDeskTypeList:(NSDictionary *)json
{
    for (NSDictionary* dic in json) {
        DeskType *oc = [DeskType deskTypeWithID :[[dic objectForKey:@"id"] integerValue] inManagedObjectContext:self.managedObjectContext];
        if (oc) {
            [self.managedObjectContext deleteObject:oc];
        }
        
        DeskType *recipe = (DeskType *)[NSEntityDescription insertNewObjectForEntityForName:@"DeskType" inManagedObjectContext:self.managedObjectContext];
        
        [recipe setTID:[NSNumber numberWithInteger:[[dic objectForKey:@"id"] integerValue]]];
        [recipe setTName:[dic objectForKey:@"name"]];
    }
    
    NSError *serror;
    if (![self.managedObjectContext save:&serror]) {
    }
}

- (void)saveUpdateDeskTypeList:(NSDictionary *)json
{
    for (NSDictionary* dic in json) {
        DeskType *recipe = [DeskType deskTypeWithID:[[dic objectForKey:@"id"] integerValue] inManagedObjectContext:self.managedObjectContext];
        if (recipe) {        
            [recipe setTID:[NSNumber numberWithInteger:[[dic objectForKey:@"id"] integerValue]]];
            [recipe setTName:[dic objectForKey:@"name"]];
        }
    }
    NSError *serror;
    if (![self.managedObjectContext save:&serror]) {
    }
}

- (void)saveDeleteDeskTypeList:(NSDictionary *)json
{
    for (NSDictionary* dic in json) {
        DeskType *recipe = [DeskType deskTypeWithID:[[dic objectForKey:@"id"] integerValue] inManagedObjectContext:self.managedObjectContext];
        if (recipe) { 
            [self.managedObjectContext deleteObject:recipe];
        }
    }
    
    NSError *serror;
    if (![self.managedObjectContext save:&serror]) {
    }
}

//新增桌子
- (void)saveAddDeskList:(NSDictionary *)json
{
    for (NSDictionary* dic in json) {
        Desk *oc = [Desk deskWithID:[[dic objectForKey:@"id"] integerValue] inManagedObjectContext:self.managedObjectContext];
        if (oc) {
            [self.managedObjectContext deleteObject:oc];
        }
        Desk *c = (Desk *)[NSEntityDescription insertNewObjectForEntityForName:@"Desk" inManagedObjectContext:self.managedObjectContext];
        
        [c setDID:[NSNumber numberWithInteger:[[dic objectForKey:@"id"] integerValue]]];
        [c setDName:[dic objectForKey:@"name"]];
        [c setDCapacity: [NSNumber numberWithInteger:[[dic objectForKey:@"capacity"] integerValue]]];
    
        NSArray * array = oc.fetchedType;
        if(array.count > 0){
            DeskType *t = (DeskType*) [array lastObject];
            [oc setDeskType:t];
        }
    }
    
    NSError *serror;
    if (![self.managedObjectContext save:&serror]) {
    }
}

- (void)saveUpdateDeskList:(NSDictionary *)json
{
    for (NSDictionary* dic in json) {
        Desk *c = [Desk deskWithID:[[dic objectForKey:@"id"] integerValue] inManagedObjectContext:self.managedObjectContext];
        if (c) {
            [c setDID:[NSNumber numberWithInteger:[[dic objectForKey:@"id"] integerValue]]];
            [c setDName:[dic objectForKey:@"name"]];
            [c setDCapacity: [NSNumber numberWithInteger:[[dic objectForKey:@"capacity"] integerValue]]];
            
            NSArray * array = c.fetchedType;
            if(array.count > 0){
                DeskType *t = (DeskType*) [array lastObject];
                [c setDeskType:t];
            }
        }
    }
    
    NSError *serror;
    if (![self.managedObjectContext save:&serror]) {
    }
}

- (void)saveDeleteDeskList:(NSDictionary *)json
{
    for (NSNumber* cid in json) {
        Desk *c = [Desk deskWithID:[cid integerValue] inManagedObjectContext:self.managedObjectContext];
        if (c) {
            [self.managedObjectContext deleteObject:c];
        }
    }
    NSError *serror;
    if (![self.managedObjectContext save:&serror]) {
    }
}

//更新时间
- (void)updateDate:(NSString *)updateDateStr
{
    [UpdateRecord deleteAllInManagedObjectContext:self.managedObjectContext];
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *updateDate =[dateFormat dateFromString:updateDateStr];
    UpdateRecord *record = (UpdateRecord *)[NSEntityDescription insertNewObjectForEntityForName:@"UpdateRecord" inManagedObjectContext:self.managedObjectContext];
    [record setUpdateTime:updateDate];
    
    NSError *serror = nil;
    if (![self.managedObjectContext save:&serror]) {
        NSLog(@"保存数据到数据库出错：%@",serror);
    }
}

@end
