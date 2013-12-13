//
//  OTViewController.h
//  BibleUrlDemo
//
//  Created by Tom Hamming on 11/9/13.
//  Copyright (c) 2013 Olive Tree Bible Software. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BibleViewType)
{
    BibleViewTypeRoot,
    BibleViewTypeBook,
    BibleViewTypeChapter
};

@interface OTViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

//Index path of the book and chapter.
//Root view does not have one.
//Book view would have path of length 1 (book number)
//Chapter view would have path of length 2 (book number, chapter number)
//It is zero-indexed, so Genesis 1 would be 0 0.
@property NSIndexPath *dataPath;

//Root, Book or Chapter
@property BibleViewType viewType;

@end
