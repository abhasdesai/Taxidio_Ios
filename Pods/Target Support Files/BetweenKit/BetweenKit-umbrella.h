#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "I3BasicRenderDelegate.h"
#import "I3CloneView.h"
#import "I3Collection.h"
#import "I3DragArena.h"
#import "I3DragDataSource.h"
#import "I3DragRenderDelegate.h"
#import "I3GestureCoordinator.h"
#import "I3Logging.h"
#import "UICollectionView+I3Collection.h"
#import "UITableView+I3Collection.h"

FOUNDATION_EXPORT double BetweenKitVersionNumber;
FOUNDATION_EXPORT const unsigned char BetweenKitVersionString[];

