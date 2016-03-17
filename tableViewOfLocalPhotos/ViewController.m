//
//  ViewController.m
//  tableViewOfLocalPhotos
//
//  Created by change009 on 16/3/15.
//  Copyright © 2016年 change009. All rights reserved.
//

#import "ViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "PTTableViewCell.h"
#import "PTViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property  (nonatomic, strong)  ALAssetsLibrary *assetsLibrary;
@property  (nonatomic, strong)  UITableView *tableView;
@property  (nonatomic, strong)  NSMutableArray *imageGroup;

@end

@implementation ViewController


-(ALAssetsLibrary *)assetsLibrary{
    
    if (!_assetsLibrary) {
        _assetsLibrary = [[ALAssetsLibrary alloc] init];
    }
    
    return _assetsLibrary;
}

-(NSMutableArray *)imageGroup{
    if (!_imageGroup) {
        _imageGroup = [[NSMutableArray alloc] init];
    }
    
    return _imageGroup;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"相册";
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.rowHeight = 82;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:self.tableView];

    
    //获取本地所有相册
    ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group,BOOL *stop){
        
        //添加过滤操作，得到所有相片
        ALAssetsFilter *onlyPhotosFilter = [ALAssetsFilter allPhotos];
        
        [group setAssetsFilter:onlyPhotosFilter];
        
        if (group.numberOfAssets) {
            //添加判断，过滤掉空的相册，得到本地所有的相册
            [self.imageGroup addObject:group];
        }else{
            [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        }
        
    };
    
    
    NSUInteger groupTypes = ALAssetsGroupAll;
    
    [self.assetsLibrary enumerateGroupsWithTypes:groupTypes usingBlock:listGroupBlock failureBlock:^(NSError *error) {
        //如果失败，可能因为授权问题
        NSLog(@"Not found any group!\n");
    }];

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.imageGroup.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *tableViewId = @"MyTableViewCellID";

    [self.tableView registerNib:[UINib nibWithNibName:@"PTTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:tableViewId];
    PTTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableViewId forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
    ALAssetsGroup *group = [self.imageGroup objectAtIndex:indexPath.row];
    cell.iconImageView.image = [UIImage imageWithCGImage:[group posterImage]];
    
    NSString *nameStr = [group valueForProperty:ALAssetsGroupPropertyName];
    if ([nameStr isEqualToString:@"Camera Roll"]) {
        nameStr = @"相机胶卷";
    }else if ([nameStr isEqualToString:@"My Photo Stream"]){
        nameStr = @"我的照片流";
    }
    cell.nameLabel.text = nameStr;
    cell.numLabel.text = [NSString stringWithFormat:@"(%ld)",group.numberOfAssets];
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    PTTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    ALAssetsGroup *seletGroup = [self.imageGroup objectAtIndex:indexPath.row];
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:0];
    
    [seletGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        

        
        
        // 1.获取相片的缩略图（模糊,但是页面非常流畅）
        UIImage *image1 = [UIImage imageWithCGImage:result.thumbnail];
        
        /*
        // 2.获取相片（比上面一种要清晰,不过如果相片多的话页面会稍显卡顿）
        UIImage *image2 = [UIImage imageWithCGImage:result.aspectRatioThumbnail];
        
        // 3.获取高清相片(比较消耗内存资源，可能会出现应用卡死)
        ALAssetRepresentation *representation = [result defaultRepresentation];
        UIImage *image3 = [UIImage imageWithCGImage:[representation fullResolutionImage]];
        
        
        // 4.获取全屏相片(同样比较消耗内存资源)
        UIImage *image4 = [UIImage imageWithCGImage:[representation fullScreenImage]];
         */
         
        if (image1) {
            [images addObject:image1];
        }
        
    }];
    
    
    PTViewController *ptViewController = [[PTViewController alloc] init];
    
    if (images.count) {
        ptViewController.imagesArr = images;
        ptViewController.ptNameStr = cell.nameLabel.text;
        [self.navigationController pushViewController:ptViewController animated:YES];
    }
    
}




@end
