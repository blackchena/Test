//
//  IDCMOTCChatController.m
//  IDCMWallet
//
//  Created by 数维科技 on 2018/5/4.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMOTCChatController.h"
#import "IDCMOTCChatCell.h"
#import "IDCMBaseBottomTipView.h"
#import "IDCMSelectPhotosTool.h"
#import "IDCMChatTextView.h"
#import "IDCMOTCChatModel.h"

@interface IDCMOTCChatController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,QMUITextViewDelegate,QMUIImagePreviewViewDelegate>


@property(nonatomic, strong) QMUIImagePreviewViewController *imagePreviewViewController;
@property (nonatomic, strong) UIImage *showImage;

//@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *datas;

@property (nonatomic, strong) UIView *inputView;

@property (nonatomic, assign) CGFloat offsetY;

@property (nonatomic, assign) NSTimeInterval lastTimeInterval;

@property (nonatomic, assign) RACDisposable *chatDisposable;
@end

@implementation IDCMOTCChatController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = viewBackgroundColor;
   
    UIView *view = self.view;
    [view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(view);
        make.top.equalTo(view); 
    }];
    
    [view addSubview:self.inputView];
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(view);
        make.top.equalTo(self.tableView.mas_bottom);
//        if (@available(iOS 11.0,*)) {
//            make.bottom.equalTo(view.mas_safeAreaLayoutGuideBottom);
//        }else{
            make.bottom.equalTo(view);
//        }
    }];
}

//- (void)setTableViewAlph:(CGFloat)alph {
//    self.tableView.alpha = alph;
//}

//- (CGFloat)getTableViewContentSize {
//    return self.tableView.height - self.tableView.contentInset.top - self.tableView.contentSize.height + self.inputView.height;
//}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self.tableView setContentOffset:CGPointMake(0, CGFLOAT_MAX)];
//    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.datas.count-1 inSection:0]  atScrollPosition:UITableViewScrollPositionNone animated:NO];
    
}

-(void)dealloc {
    [[IDCMOTCSignalRTool sharedOTCSignal] leaveChatGroup];
//    [IQKeyboardManager sharedManager].enable = YES;
    [self.chatDisposable dispose];
}

- (void)bindViewModel {
    self.datas = @[];
//    self.orderID = @"123456789";
    
    [[IDCMOTCSignalRTool sharedOTCSignal] addChatGroup:self.orderID];
    
    @weakify(self);
    UIButton *button = self.inputView.subviews.lastObject;
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self.view endEditing:YES];
        [IDCMBottomListTipView showTipViewToView:nil titleArray:@[SWLocaloziString(@"3.0_Chat_TakePhoto"),SWLocaloziString(@"3.0_Chat_Photo"),SWLocaloziString(@"3.0_Chat_Cancle")] itemClickCallback:^(NSInteger index, id title) {
            if (index == 2){
                return ;
            }
            [[IDCMSelectPhotosTool sharedSelectPhotosTool] selectSiglePhotoFromCamera:index == 0 thumbnailWithSize:CGSizeZero completeCallback:^(UIImage *thumbnailPhoto, UIImage *originPhoto) {
                UIImage *img = [UIImage imageWithData:UIImageJPEGRepresentation(originPhoto, 0.2)];
                [[RACScheduler mainThreadScheduler] schedule:^{
                    [self sendContent:img isText:NO];
                }];
            }];
        }];
    }];
    
//    [self.tableView.panGestureRecognizer addActionBlock:^(id  _Nonnull sender) {
//        @strongify(self);
//        !self.tapActionCallback ?: self.tapActionCallback();
//        [self.view endEditing:YES];
//    }];
    
    
    // 推送
    self.chatDisposable = [[IDCMOTCSignalRTool sharedOTCSignal].otcChatMessageSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        IDCMOTCChatModel * model = [IDCMOTCChatModel yy_modelWithJSON:x];
        if (model == nil) {
            return ;
        }
        NSString *userID = [NSString stringWithFormat:@"%@",model.UserID];
        // 过滤非自己的用户消息
        if(model.ChatObjectCategory == 0){
            if (! [userID isEqualToString:[IDCMDataManager sharedDataManager].userID]) {
                return;
            }
            [self addModel:model];
        }
        else{ 
            if(![model j_send]){
                [self addModel:model];
            }
        }
    }];
    NSString *url = [NSString stringWithFormat:@"%@?groupName=%@",GetChatHistory_URL,self.orderID];
    [[[RACSignal signalGetNotAuth:url serverName:nil params:nil handleSignal:nil] deliverOnMainThread]
     subscribeNext:^(NSDictionary *response) {
         @strongify(self);
         NSInteger  StatusCode = [response[@"status"] integerValue];
         NSArray *data = response[@"data"];
         if (StatusCode == 1 && [data isKindOfClass:[NSArray class]]) {
             NSArray *arr = [NSArray yy_modelArrayWithClass:[IDCMOTCChatModel class] json:data];
             NSMutableArray *datas = @[].mutableCopy;
             NSTimeInterval time = 0;
             for (IDCMOTCChatModel *model in arr) {
                 NSInteger offset = ABS(time - model.TimeStamp);
                 model.showTime = offset > 3 * 60 * 1000;
                 time = model.TimeStamp;
                 if(model.ChatObjectCategory == 0){
                     NSString *userID = [NSString stringWithFormat:@"%@",model.UserID];
                     if (! [userID isEqualToString:[IDCMDataManager sharedDataManager].userID]) {
                         continue;
                     }
                 }
                 [datas addObject:model];
             }
             self.datas = datas.copy;
             [self.tableView reloadData];

             [self setToBottom:NO];
         }
     }];
    
}

- (void)refreshInputViewTransform:(CGAffineTransform)transform {
    self.inputView.transform = transform;
}

- (void)refreshTableViewTransform:(CGAffineTransform)transform {
    self.tableView.transform = transform;
}
-(void)setIsSell:(BOOL)isSell {
    IDCMChatTextView *textView = self.inputView.subviews.firstObject;
    textView.placeholder = isSell ? SWLocaloziString(@"3.0_Chat_InputPlaceholder1") : SWLocaloziString(@"3.0_Chat_InputPlaceholder");
}

- (void)setToBottom:(BOOL)animated{
    CGFloat ff = self.tableView.contentSize.height + 12 - self.tableView.bounds.size.height ;
    //             ff = ff > 0 ? ff + 6 : ff;
    //             CGPoint bottomOffset = CGPointMake(0, MAX(-6, ff));
    //             [self.tableView setContentOffset:bottomOffset animated:NO];
    if (ff > 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.datas.count - 1 inSection:0]  atScrollPosition:UITableViewScrollPositionNone animated:animated];
    }
}

-(void)orderDown {
    self.inputView.hidden = YES;
    [self.inputView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.tableView.mas_bottom);
        make.bottom.equalTo(self.view);
        make.height.equalTo(@0);
    }];
}

- (void)orderDoing {
    if (self.inputView.hidden) {
        self.inputView.hidden = NO;
        [self.inputView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(self.tableView.mas_bottom);
            make.bottom.equalTo(self.view);
        }];
    }
}

#pragma mark - Send

- (void)addModel:(IDCMOTCChatModel *)model{
    IDCMOTCChatModel *oldModel = self.datas.lastObject;
    NSInteger offset = ABS(model.TimeStamp - oldModel.TimeStamp);
    if(offset <= 50){
        return;
    }
    model.showTime = offset > 3 * 60 * 1000;
    
    @synchronized(self) {
        dispatch_async(dispatch_get_main_queue(), ^{

            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:MAX(0, [self.tableView numberOfRowsInSection:0]) inSection:0];
            [self.tableView beginUpdates];
            NSMutableArray *arr = self.datas.mutableCopy;
            [arr addObject:model];
            self.datas = arr.copy;
            [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
            if (indexPath.row > 3) {
                [self.tableView scrollToRowAtIndexPath:indexPath  atScrollPosition:UITableViewScrollPositionNone animated:YES];
            }
        });
    }
}

- (void)sendContent:(id)content isText:(BOOL) isText {
    IDCMOTCChatModel *model = [[IDCMOTCChatModel alloc]init];
    model.SendUserID = [IDCMDataManager sharedDataManager].userID;
    model.UserID = [IDCMDataManager sharedDataManager].userID;
    model.ChatObjectCategory = 1;
    model.TimeStamp = (NSInteger)[[NSDate date]timeIntervalSince1970] *1000;
    if (isText) {
        model.Message = content;
    }
    else{
        model.FileUrl = content;
    }
    
    NSInteger index = self.datas.count;
    
    [self addModel:model];
    IDCMOTCChatType type = isText ? kIDCMOTCChatMessageType : kIDCMOTCChatImageType;
    @weakify(self);
    [[IDCMOTCSignalRTool sharedOTCSignal] sendChatType:type  andWithContent:content completionHandler:^(RACSignal *signal) {
//        [signal subscribeNext:^(id  _Nullable x) {
//
//        }];
        [signal subscribeError:^(NSError * _Nullable error) {
            DDLogDebug(@"send=chat===%@",error);
            @strongify(self);
            [self sendError:index];
        }];
    }];
}

- (void)sendError:(NSInteger )index{
    if (self.datas.count == 0 || index >= self.datas.count) {
        return;
    }
    IDCMOTCChatModel *model = self.datas[index];
    model.sendFail = YES;
    [[RACScheduler mainThreadScheduler] schedule:^{
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
}

- (void)retrySend:(NSInteger )index{
    IDCMOTCChatModel * model = self.datas[index];
    NSMutableArray *arr = self.datas.mutableCopy;
    [arr removeObjectAtIndex:index];
    self.datas = arr.copy;
    [self.tableView reloadData];
    BOOL isText = [model j_isText];
    id content = isText ? model.Message : model.FileUrl;
    [self sendContent:content isText:isText];
}

#pragma mark - QMUITextViewDelegate
-(BOOL)textViewShouldReturn:(QMUITextView *)textView {
    NSString *text = textView.text;
    if(text.length <= 0){
        return YES;
    }
    
    [self sendContent:text isText:YES];
    textView.text = @"";
    return YES;
}

#pragma mark - UItablView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IDCMOTCChatModel * model = self.datas[indexPath.row];
    NSString *cellID = NSStringFromClass([IDCMOTCChatCell class]);
    IDCMOTCChatCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.backgroundColor = tableView.backgroundColor;
    cell.model = model;
    cell.tableView = tableView;
    cell.indexPath = indexPath;
    @weakify(self);
    cell.chatTapImageView = ^(UIImage *img){
        if(img){
            @strongify(self);
            [self.view endEditing:YES];
            self.showImage = img;
            [self.imagePreviewViewController startPreviewByFadeIn];
        }
    };
    cell.chatTapRetryButton = ^(NSIndexPath *indexPath) {
        @strongify(self);
        [self.view endEditing:YES];
        [self retrySend:indexPath.row];
    };
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 
}

#pragma mark - <QMUIImagePreviewViewDelegate>

- (NSUInteger)numberOfImagesInImagePreviewView:(QMUIImagePreviewView *)imagePreviewView {
    return self.showImage != nil ? 1 : 0;
}

- (void)imagePreviewView:(QMUIImagePreviewView *)imagePreviewView renderZoomImageView:(QMUIZoomImageView *)zoomImageView atIndex:(NSUInteger)index {
    zoomImageView.image = self.showImage;
}

- (QMUIImagePreviewMediaType)imagePreviewView:(QMUIImagePreviewView *)imagePreviewView assetTypeAtIndex:(NSUInteger)index {
    return QMUIImagePreviewMediaTypeImage;
}
- (void)singleTouchInZoomingImageView:(QMUIZoomImageView *)zoomImageView location:(CGPoint)location {
    [self.imagePreviewViewController exitPreviewByFadeOut];
}

#pragma mark - Get/Set
-(UIView *)inputView {
    return SW_LAZY(_inputView , ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        
        IDCMChatTextView *textView = [[IDCMChatTextView alloc]init];
        textView.placeholder = @" ";//SWLocaloziString(@"3.0_Chat_InputPlaceholder");
        textView.placeholderColor = [UIColor colorWithHexString:@"#999999"];
        textView.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
//        textView.autoResizable = YES;
        textView.maximumTextLength = 300;
        textView.delegate = self;
        textView.bounces = NO;
        textView.showsVerticalScrollIndicator = NO;
        textView.returnKeyType = UIReturnKeySend;
        textView.textColor = [UIColor blackColor];
        textView.minHeight = 30;
        textView.maxHeight = 80;
        [view addSubview:textView];
        [textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(view).offset(10);
            make.centerY.equalTo(view);
            make.height.equalTo(@(30));
            make.right.equalTo(view).offset(-10);
        }];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"3.2_chat_相机-icon"] forState:UIControlStateNormal];
        [view addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view);
            make.left.equalTo(view).offset(10);
            make.right.equalTo(textView.mas_left).offset(-10);
            make.width.equalTo(button.mas_height);
        }];
        view;
    }));
}

-(UITableView *)tableView {
    return SW_LAZY(_tableView , ({
        UITableView *view = [[UITableView alloc] init];
        view.rowHeight = UITableViewAutomaticDimension;
        view.estimatedRowHeight = 100;
        NSString *cellID = NSStringFromClass([IDCMOTCChatCell class]);
        [view registerNib:[UINib nibWithNibName:cellID bundle:nil] forCellReuseIdentifier:cellID];
        view.dataSource = self;
        view.delegate = self;
        view.emptyDataSetSource = self;
        view.emptyDataSetDelegate = self;
        view.backgroundColor = viewBackgroundColor;
        view.separatorStyle = UITableViewCellSeparatorStyleNone;
        view.showsVerticalScrollIndicator = NO;
        view.contentInset = UIEdgeInsetsMake(6, 0, 6, 0);
        
        view;
    }));
}

- (QMUIImagePreviewViewController *)imagePreviewViewController{
    return SW_LAZY(_imagePreviewViewController , ({
        QMUIImagePreviewViewController *imagePreviewViewController = [[QMUIImagePreviewViewController alloc] init];
        imagePreviewViewController.imagePreviewView.delegate = self;
        imagePreviewViewController;
    }));
}
@end
