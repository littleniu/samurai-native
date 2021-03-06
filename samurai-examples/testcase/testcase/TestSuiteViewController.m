//
//  ViewController.m
//  test
//
//  Created by god on 15/4/29.
//  Copyright (c) 2015年 Geek-Zoo Studio. All rights reserved.
//

#import "TestSuiteViewController.h"
#import "TestCaseViewController.h"

@implementation TestSuiteViewController
{
	UITableView *		_tableView;
	NSMutableArray *	_files;
}

@synthesize testSuite;

- (void)dealloc
{
	[self unloadViewTemplate];
}

- (void)viewDidLoad {
	
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

	_files = [[NSMutableArray alloc] init];
	
	NSString * basePath = [[NSBundle mainBundle] pathForResource:@"/www/html/testcases" ofType:nil inDirectory:nil];

	if ( nil == self.testSuite )
	{
		self.testSuite = basePath;
	}

	NSArray * contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.testSuite error:NULL];
	
	for ( NSString * subPath in contents )
	{
		NSString * fullPath = [[self.testSuite stringByAppendingPathComponent:subPath] stringByStandardizingPath];
		if ( nil == fullPath )
			continue;

		BOOL isDir = NO;
		BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:fullPath isDirectory:&isDir];
		if ( exists )
		{
			if ( isDir )
			{
				[_files addObject:fullPath];
			}
			else if ( [fullPath hasSuffix:@".html"] )
			{
				[_files addObject:fullPath];
			}
		}
	}
	
	[_files sortUsingSelector:@selector(compare:)];

	[self loadViewTemplate:@"/www/html/test-suite.html"];

	self.navigationBarTitle = self.testSuite;
	self.navigationBarTitle = [self.testSuite lastPathComponent];
}

- (void)didReceiveMemoryWarning {
	
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

#pragma mark -

- (void)onTemplateLoading
{
	
}

- (void)onTemplateLoaded
{
	self[@"list"] = @{
					  
		@"items" : ({
			
			NSMutableArray * array = [NSMutableArray array];

			for ( NSString * path in _files )
			{
				BOOL isDir = NO;
				
				[[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir];
				
				if ( isDir )
				{
					[array addObject:@{ @"title" : [NSString stringWithFormat:@"%@ >", [path lastPathComponent]] }];
				}
				else
				{
					[array addObject:@{ @"title" : [path lastPathComponent] }];
				}
			}

			array;
		})
	};
}

- (void)onTemplateFailed
{
	
}

- (void)onTemplateCancelled
{
	
}

#pragma mark -

handleSignal( test )
{
	BOOL isDir = NO;
	
	NSString * path = [_files objectAtIndex:signal.sourceIndexPath.row];
	
	[[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir];

	if ( isDir )
	{
		TestSuiteViewController * viewController = [[TestSuiteViewController alloc] init];
		viewController.testSuite = path;
		[self.navigationController pushViewController:viewController animated:YES];
	}
	else
	{
		TestCaseViewController * viewController = [[TestCaseViewController alloc] init];
		viewController.testCase = path;
		[self.navigationController pushViewController:viewController animated:YES];
	}
}

@end
