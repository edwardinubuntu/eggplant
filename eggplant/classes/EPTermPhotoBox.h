//
//  EPTermPhotoBox.h
//  eggplant
//
//  A collectionView-like box of photo that represents a search term in menu
//  Derived from MGBox2
//
//  Created by Ben on 07/02/2013.
//

#import "MGBox.h"

@interface EPTermPhotoBox : MGBox

+ (EPTermPhotoBox *)photoBoxForIndex:(NSInteger)index withSize:(CGSize)size imageURL:(NSString *)url;

@end
