//
//  TTGTagCollectionView-Bridging-Header.h
//  TTGTagCollectionView
//
//  Created by zekunyan on 2021/4/21.
//

#ifndef TTGTagCollectionView_Bridging_Header_h
#define TTGTagCollectionView_Bridging_Header_h

#if SWIFT_PACKAGE
#import "TTGTagCollectionView.h"
#import "TTGTextTagCollectionView.h"
#import "TTGTextTag.h"
#import "TTGTextTagContent.h"
#import "TTGTextTagStringContent.h"
#import "TTGTextTagAttributedStringContent.h"
#import "TTGTextTagStyle.h"
#else
#import <TTGTagCollectionView/TTGTagCollectionView.h>
#import <TTGTagCollectionView/TTGTextTagCollectionView.h>
#import <TTGTagCollectionView/TTGTextTag.h>
#import <TTGTagCollectionView/TTGTextTagContent.h>
#import <TTGTagCollectionView/TTGTextTagStringContent.h>
#import <TTGTagCollectionView/TTGTextTagAttributedStringContent.h>
#import <TTGTagCollectionView/TTGTextTagStyle.h>
#endif

#endif /* TTGTagCollectionView_Bridging_Header_h */
