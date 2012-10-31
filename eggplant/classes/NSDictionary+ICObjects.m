//
//  NSDictionary+ICObjects.m
//  iCook
//
//  Created by Edward Chiang on 12/6/20.
//  Copyright (c) 2012年 Polydice, Inc. All rights reserved.
//

#import "NSDictionary+ICObjects.h"

@implementation NSDictionary (ICObjects)

- (ICRecipe *)extractRecipe {
  ICRecipe *recipe = [[ICRecipe alloc] init];
  recipe.recipeDescription = [self objectForKey:@"description"];
  if ([self objectForKey:@"done_by_login_user"]) {
    recipe.hasDoneByCurrentUser = [[self objectForKey:@"done_by_login_user"] isEqualToString:@"yes"];
  }
  if ([self objectForKey:@"likes_count"] && ![[self objectForKey:@"likes_count"] isKindOfClass:[NSNull class]]) {
    recipe.likesCount = [[self objectForKey:@"likes_count"] intValue];
  }
  recipe.URL = [NSURL URLWithString:[self objectForKey:@"url"]];
  if ([self objectForKey:@"views_count"] && ![[self objectForKey:@"views_count"] isKindOfClass:[NSNull class]]) {
    recipe.viewsCount = [[self objectForKey:@"views_count"] intValue];
  }
  recipe.name = [self objectForKey:@"name"];
  if ([self objectForKey:@"id"] && ![[self objectForKey:@"id"] isKindOfClass:[NSNull class]]) {
    recipe.objectID = [[self objectForKey:@"id"] intValue];
  }
  recipe.tips = [self objectForKey:@"tips"];
  if ([self objectForKey:@"comments_count"] && ![[self objectForKey:@"comments_count"] isKindOfClass:[NSNull class]]) {
    recipe.commentsCount = [[self objectForKey:@"comments_count"] intValue];
  }
  if ([self objectForKey:@"favorites_count"] && ![[self objectForKey:@"favorites_count"] isKindOfClass:[NSNull class]]) {
    recipe.favoritesCount = [[self objectForKey:@"favorites_count"] intValue];
  }
  if ([self objectForKey:@"dishes_count"] && ![[self objectForKey:@"dishes_count"] isKindOfClass:[NSNull class]]) {
    recipe.dishesCount = [[self objectForKey:@"dishes_count"] intValue];
  }
  if ([self objectForKey:@"ranking"] && ![[self objectForKey:@"ranking"] isKindOfClass:[NSNull class]]) {
    recipe.ranking = [[self objectForKey:@"ranking"] floatValue];
  }
  if ([self objectForKey:@"facebook_object_id"] && ![[self objectForKey:@"facebook_object_id"] isKindOfClass:[NSNull class]]) {
    recipe.facebookObjectID = [[self objectForKey:@"facebook_object_id"] longValue];
  }
  
  NSDictionary *photoDict = [self objectForKey:@"cover_pictures"];
  ICPhoto *photo = [self extractPhotos:photoDict];
  recipe.photos = photo;
  
  recipe.isDoneByUser = [[self objectForKey:@"done_by_login_user"] isEqualToString:@"yes"];
  recipe.isFavoritedByUser = [[self objectForKey:@"favorited_by_login_user"] isEqualToString:@"yes"];
  return recipe;
}

- (ICUser *)extractUser {
  ICUser *user = [[ICUser alloc] init];
  user.avatarURL = [NSURL URLWithString:[self objectForKey:@"avatar_image_url"]];
  user.username = [self objectForKey:@"username"];
  user.nickname = [self objectForKey:@"nickname"];
  user.email = [self objectForKey:@"email"];
  user.birthday = [self objectForKey:@"birthday"];
  user.userDescription = [self objectForKey:@"descripiton"];
  if ([self objectForKey:@"blog_url"] && ![[self objectForKey:@"blog_url"] isKindOfClass:[NSNull class]]) {
    user.blogURL = [NSURL URLWithString:[self objectForKey:@"blog_url"]];
  }
  
  user.gender = [self objectForKey:@"gender"];
  if ([self objectForKey:@"facebook_uid"] && ![[self objectForKey:@"facebook_uid"] isKindOfClass:[NSNull class]]) {
    user.facebookUID = [[self objectForKey:@"facebook_uid"] intValue];
  }
  
  user.provider = [self objectForKey:@"provider"];
  if ([self objectForKey:@"recipes_count"] && ![[self objectForKey:@"recipes_count"] isKindOfClass:[NSNull class]]) {
    user.recipesCount = [[self objectForKey:@"recipes_count"] intValue];
  }
  
  if ([self objectForKey:@"dishes_count"] && ![[self objectForKey:@"dishes_count"] isKindOfClass:[NSNull class]]) {
    user.dishesCount = [[self objectForKey:@"dishes_count"] intValue];
  }
  if ([self objectForKey:@"followers_count"] && ![[self objectForKey:@"followers_count"] isKindOfClass:[NSNull class]]) {
    user.followersCount = [[self objectForKey:@"followers_count"] intValue];
  }
  return user;
}

- (ICPhoto *)extractPhotos:(NSDictionary *)photoDict {
  if (![photoDict isKindOfClass:[NSDictionary class]]) {
    return nil;
  }
  ICPhoto *photo = [[ICPhoto alloc] init];
  if ([[photoDict objectForKey:@"medium"] objectForKey:@"url"]) {
    photo.mediumURL = [[NSURL alloc] initWithString:[[photoDict objectForKey:@"medium"] objectForKey:@"url"]];
  }
  if ([[photoDict objectForKey:@"square"] objectForKey:@"url"]) {
    photo.squareURL = [[NSURL alloc] initWithString:[[photoDict objectForKey:@"square"] objectForKey:@"url"]];
  }
  if ([[photoDict objectForKey:@"small"] objectForKey:@"url"]) {
    photo.smallURL = [[NSURL alloc] initWithString:[[photoDict objectForKey:@"small"] objectForKey:@"url"]];
  }
  if ([[photoDict objectForKey:@"large"] objectForKey:@"url"]) {
    photo.largeURL = [[NSURL alloc] initWithString:[[photoDict objectForKey:@"large"] objectForKey:@"url"]];
  }
  return photo;
}

@end
