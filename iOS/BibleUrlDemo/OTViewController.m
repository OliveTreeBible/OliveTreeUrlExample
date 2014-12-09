//
//  OTViewController.m
//  BibleUrlDemo
//
//  Created by Tom Hamming on 11/9/13.
//  Copyright (c) 2013 Olive Tree Bible Software. All rights reserved.
//

#import "OTViewController.h"

@interface OTViewController ()
@property NSDictionary *bibleData;
@property NSArray *bookNumbers;
@property (strong) NSComparator stringSorter;

-(NSString *)bookNameAtIndex:(NSInteger)index;
-(NSInteger)numberOfChaptersInBookAtindex:(NSInteger)index;
-(NSInteger)numberOfVersesInBook:(NSInteger)book chapter:(NSInteger)chapter;
@end

@implementation OTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!self.dataPath)
        self.viewType = BibleViewTypeRoot;
    
    //Load the JSON verse data
    NSString *path = [[NSBundle mainBundle] pathForResource:@"BibleJson" ofType:@"txt"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSError *err = nil;
    self.bibleData = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
    
    //Block to sort two numeric strings in numeric order, not alpha order
    self.stringSorter = ^(id obj1, id obj2)
    {
        NSString *str1 = (NSString *)obj1;
        NSString *str2 = (NSString *)obj2;
        if ([str1 intValue] > [str2 intValue])
            return NSOrderedDescending;
        else if ([str2 intValue] > [str1 intValue])
            return NSOrderedAscending;
        else
            return NSOrderedSame;
    };
    
    //Cache the sorted book numbers from the JSON data
    self.bookNumbers = [self.bibleData.allKeys sortedArrayUsingComparator:self.stringSorter];
    
    //Set the view title as necessary
    if (self.viewType == BibleViewTypeRoot)
        self.navigationItem.title = @"Bible";
    else if (self.viewType == BibleViewTypeBook)
        self.navigationItem.title = [self bookNameAtIndex:[self.dataPath indexAtPosition:0]];
    else
        self.navigationItem.title = [NSString stringWithFormat:@"%@ %i", [self bookNameAtIndex:[self.dataPath indexAtPosition:0]], (int)[self.dataPath indexAtPosition:1] + 1];
}

-(void)loadView
{
    //If we're presenting from code and not the storyboard, load the tableview
    [super loadView];
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.viewType == BibleViewTypeRoot)
    {
        //We're looking at the list of books, so make a new view controller for this book's chapters and show it
        OTViewController *newController = [[OTViewController alloc]init];
        newController.dataPath = [NSIndexPath indexPathWithIndex:indexPath.row];
        newController.viewType = BibleViewTypeBook;
        [self.navigationController pushViewController:newController animated:YES];
    }
    else if (self.viewType == BibleViewTypeBook)
    {
        //We're looking at the list of chapters in a book, so make a new view controller for this chapter's verses and show it
        OTViewController *newController = [[OTViewController alloc]init];
        newController.dataPath = [NSIndexPath indexPathForRow:indexPath.row inSection:[self.dataPath indexAtPosition:0]];
        newController.viewType = BibleViewTypeChapter;
        [self.navigationController pushViewController:newController animated:YES];
    }
    else
    {
        //Navigate to a verse
        NSInteger bookIndex = [self.dataPath indexAtPosition:0];
        NSString *book = [self bookNameAtIndex:bookIndex];
        NSInteger chapterIndex = [self.dataPath indexAtPosition:1];
        
        //Generate a normal scripture reference of the form <book_name> <chapter>:<verse>
        //Chapter and verse are zero-indexed, so add 1
        NSString *scriptureRef = [NSString stringWithFormat:@"%@ %i:%i", book, (int)chapterIndex + 1, (int)indexPath.row + 1];
        
        //Replace space with the HTML escape (%20)
        scriptureRef = [scriptureRef stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        
        //Replace : with .
        scriptureRef = [scriptureRef stringByReplacingOccurrencesOfString:@":" withString:@"."];
        
        //Prefix to the URL
        NSString *oliveTreeUrl = @"olivetree://bible/";
        
        //Concatenate the two strings to form a complete Olive Tree URL
        oliveTreeUrl = [oliveTreeUrl stringByAppendingString:scriptureRef];
        NSLog(@"Opening URL: %@", oliveTreeUrl);
        
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:oliveTreeUrl]])
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:oliveTreeUrl]];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Open URL" message:[NSString stringWithFormat:@"URL generated is '%@', but Olive Tree doesn't appear to be installed.", oliveTreeUrl] delegate:Nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
        }
    }
}

#pragma mark - UITableView data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.viewType == BibleViewTypeRoot)
    {
        //If this is the root view, then we want the number of books
        return self.bibleData.allKeys.count;
    }
    else if (self.viewType == BibleViewTypeBook)
    {
        //If this is a book view, we want the number of chapters in the book
        return [self numberOfChaptersInBookAtindex:[self.dataPath indexAtPosition:0]];
    }
    else
    {
        //If this is a chapter view, we want the number of verses in the chapter
        return [self numberOfVersesInBook:[self.dataPath indexAtPosition:0] chapter:[self.dataPath indexAtPosition:1]];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"MyIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
        cell = [[UITableViewCell alloc]init];
    
    if (self.viewType == BibleViewTypeRoot)
    {
        cell.textLabel.text = [self bookNameAtIndex:indexPath.row];
    }
    else if (self.viewType == BibleViewTypeBook)
    {
        NSInteger bookIndex = [self.dataPath indexAtPosition:0];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %i", [self bookNameAtIndex:bookIndex], (int)indexPath.row + 1];
    }
    else //chapter
    {
        NSInteger bookIndex = [self.dataPath indexAtPosition:0];
        NSString *book = [self bookNameAtIndex:bookIndex];
        NSInteger chapterIndex = [self.dataPath indexAtPosition:1];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %i:%i", book, (int)chapterIndex + 1, (int)indexPath.row + 1];
    }
    
    return cell;
}

#pragma mark - Private

-(NSInteger)numberOfChaptersInBookAtindex:(NSInteger)index
{
    //Get the number of the book at the index we want
    NSString *key = (NSString *)[self.bookNumbers objectAtIndex:index];
    
    //Get the dictionary data for that book
    NSDictionary *data = (NSDictionary *)[self.bibleData objectForKey:key];
    
    //Get the dictionary of chapters for that book
    NSDictionary *chapters = (NSDictionary *)[data objectForKey:@"chapters"];
    return chapters.allKeys.count;
}

-(NSString *)bookNameAtIndex:(NSInteger)index
{
    //Get the number of the book at the index we want
    NSString *key = (NSString *)[self.bookNumbers objectAtIndex:index];
    
    //Get the dictionary data for that book
    NSDictionary *data = (NSDictionary *)[self.bibleData objectForKey:key];
    
    //Get the name object
    return [data objectForKey:@"name"];
}

-(NSInteger)numberOfVersesInBook:(NSInteger)book chapter:(NSInteger)chapter
{
    //Get the number of the book at the index we want
    NSString *key = (NSString *)[self.bookNumbers objectAtIndex:book];
    
    //Get the dictionary data for that book
    NSDictionary *data = (NSDictionary *)[self.bibleData objectForKey:key];
    
    //Get the chapter data for that book
    NSDictionary *chapters = (NSDictionary *)[data objectForKey:@"chapters"];
    
    //Get a sorted array of the chapter numbers in that book
    NSArray *chapterNumbersSorted = [chapters.allKeys sortedArrayUsingComparator:self.stringSorter];
    
    //Get the chapter number at our index
    NSString *chapterKey = [chapterNumbersSorted objectAtIndex:chapter];
    
    //Get the number of verses
    NSString *number = [chapters objectForKey:chapterKey];
    
    //Return the integer value
    return [number integerValue];
}

@end
