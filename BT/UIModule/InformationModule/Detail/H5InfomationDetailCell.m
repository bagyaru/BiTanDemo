//
//  H5InfomationDetailCell.m
//  BT
//
//  Created by admin on 2018/11/6.
//  Copyright © 2018 apple. All rights reserved.
//

#import "H5InfomationDetailCell.h"

@implementation H5InfomationDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    ViewBorderRadius(self.viewDS, 18, 1, BtnBorderColor);
    ViewBorderRadius(self.viewZan, 18, 1, BtnBorderColor);
    // Initialization code
}
-(void)creatUIWith:(NSString *)str isOrNoFirst:(BOOL)isOrNoFirst model:(THFZXAndBKObj *)model bigType:(NSInteger)bigType{
    
    //[self.webView loadHTMLString:str baseURL:nil];
    if (ISNSStringValid(str)&&isOrNoFirst) {//防止重复创建
        [self.h5View removeAllSubviews];
        _webView = [[WKWebView alloc] init];
        [self.h5View addSubview:_webView];
        _webView.frame = CGRectMake(0, 0, ScreenWidth-20, ScreenHeight);
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
        _webView.scrollView.scrollEnabled = NO;
        _webView.scrollView.backgroundColor = isNightMode ? TableViewCellNightColor : KWhiteColor;
        _webView.backgroundColor = isNightMode ? TableViewCellNightColor : KWhiteColor;
        [_webView setOpaque:!isNightMode];
        [self.webView loadHTMLString:[self reSizeImageWithHTML:str] baseURL:nil];
    }
    if (model) {
        _model = model;
        _bigType = bigType;
        self.labelZan.text = model.good > 0 ? [NSString stringWithFormat:@"  %ld",(long)model.good] : [APPLanguageService wyhSearchContentWith:@"dianzan"];
        self.downView.hidden = ISStringEqualToString(model.whereVC, @"公告");
        self.downViewH.constant = ISStringEqualToString(model.whereVC, @"公告") ? 0 : 96;
        if (!model.likeStatus) {
            //self.labelZan.text = [APPLanguageService wyhSearchContentWith:@"dianzan"];
            [self.imageViewZan setImage:IMAGE_NAMED(@"我的帖子-评论点赞-1")];
        }else{
            //self.labelZan.text = [NSString stringWithFormat:@"  %ld",model.good];
            [self.imageViewZan setImage:IMAGE_NAMED(@"我的帖子-评论点赞-2")];
        }
    }
    
}
- (NSString *)reSizeImageWithHTML:(NSString *)html {
    
    return [NSString stringWithFormat:@"<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'><style type='text/css'>img{width:100%%;height:auto} iframe{width:100%%;height:auto} body{font-family: Heiti SC}</style>%@",html];

}
#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    DLog(@"");
    self.isFinishLoading = YES;
    // 1、只对本地html资源的图片有效果
    //[self threeAutoHeight:webView];
    static  NSString * const jsGetImages =
    @"function getImages(){\
    var objs = document.getElementsByTagName(\"img\");\
    var imgScr = '';\
    for(let i=0;i<objs.length;i++){\
    imgScr = imgScr + objs[i].src +'LQXindex'+ i +'L+Q+X';\
    objs[i].onclick=function(){\
    document.location=\"myweb:imageClick:\"+this.src + 'LQXindex' + i;\
    };\
    };\
    return imgScr;\
    };";
    
    [webView evaluateJavaScript:jsGetImages completionHandler:^(id _Nullable _id, NSError * _Nullable error) {
        DLog(@"error:%@", error);
    }];
    //得到图片数组
    [webView evaluateJavaScript:@"getImages()" completionHandler:^(id _Nullable _id, NSError * _Nullable error) {
        DLog(@"error:%@", error);
        NSString *urlResurlt = _id;
        _allUrlArray = [NSMutableArray arrayWithArray:[urlResurlt componentsSeparatedByString:@"L+Q+X"]];
        if (_allUrlArray.count >= 2) {
            [_allUrlArray removeLastObject];//
        }
        
    }];
    //计算高度
    dispatch_async(dispatch_get_main_queue(), ^{
        [webView evaluateJavaScript:@"document.body.scrollHeight" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            
            //获取页面高度，并重置webview的frame
            CGFloat documentHeight = [result doubleValue];
            CGRect frame = webView.frame;
            frame.size.height = documentHeight;
            webView.frame = frame;
            NSLog(@"%.0f",documentHeight);
            if (self.delegate && [self.delegate respondsToSelector:@selector(THFZXAndBKCellHeight:)]) {
                
                [self.delegate THFZXAndBKCellHeight:documentHeight+self.downViewH.constant];
            }
        }];
    });
    //修改背景色
    //[webView evaluateJavaScript:[NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.background='#%@'",isNightMode ? @"222229" : @"ffffff"] completionHandler:nil];
    // 改变网页内容文字颜色
    
    [webView evaluateJavaScript:[NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#%@'",isNightMode ? @"BACDE6" : @"333333"] completionHandler:nil];
}
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    if(error.code ==NSURLErrorCancelled){
        return;
    }
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    
}
// 类似 UIWebView 的 -webView: shouldStartLoadWithRequest: navigationType:
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    [self showBigImage:navigationAction.request];
    if([navigationAction.request.URL.absoluteString hasPrefix:@"http"]||[navigationAction.request.URL.absoluteString hasPrefix:@"https"]){
        if([navigationAction.request.URL.absoluteString containsString:@"iframe"]){
            //            decisionHandler(WKNavigationActionPolicyCancel);
            //            return;
        }else{
            NSLog(@"%@",navigationAction.request.URL.absoluteString);
            if(![navigationAction.request.URL.absoluteString containsString:@"video"]){
                H5Node *node = [[H5Node alloc] init];
                node.webUrl = navigationAction.request.URL.absoluteString;
                [BTCMInstance pushViewControllerWithName:@"webView" andParams:@{@"node":node}];
                decisionHandler(WKNavigationActionPolicyCancel);
                return;
            }
        }

    }
    decisionHandler(WKNavigationActionPolicyAllow);
}
//显示大图
-(BOOL)showBigImage:(NSURLRequest *)request {
    //将url转换为string
    NSString *requestString = [[request URL] absoluteString];
    //hasPrefix 判断创建的字符串内容是否以pic:字符开始
    if ([requestString hasPrefix:@"myweb:imageClick:"]) {
        NSString *imageUrl = [requestString substringFromIndex:@"myweb:imageClick:".length];
        NSArray *imageIndex = [NSMutableArray arrayWithArray:[imageUrl componentsSeparatedByString:@"LQXindex"]];
        int i = [imageIndex.lastObject intValue];
        
        NSMutableArray *imagesArr = @[].mutableCopy;
        for (int i = 0; i < _allUrlArray.count; i++) {
            NSString *url = _allUrlArray[i];
            NSArray *images = [NSMutableArray arrayWithArray:[url componentsSeparatedByString:@"LQXindex"]];
            //            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:images.firstObject]]];
            [imagesArr addObject:images.firstObject];
        }
        [getUserCenter PreviewImageSCreatPhotoBrowserVCWithImages:imagesArr andIndexPath:i];
        return NO;
    }
    return YES;
}
#pragma mark- WKUIDelegate
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        completionHandler();
    }]];
    [getMainTabBar presentViewController:alertController animated:YES completion:^{}];
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        completionHandler(YES);
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        completionHandler(NO);
    }]];
    [getMainTabBar presentViewController:alertController animated:YES completion:^{}];
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable result))completionHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:defaultText preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.text = defaultText;
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSString *input = ((UITextField *)alertController.textFields.firstObject).text;
        completionHandler(input);
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        completionHandler(nil);
    }]];
    [getMainTabBar presentViewController:alertController animated:YES completion:^{}];
}

//打赏
- (IBAction)dashangBtnClick:(UIButton *)sender {
    if (self.bigType == 6) {
        [MobClick event:@"tanbao_detail_dashang"];
    }else {
        if (self.model.type == 2) {
            [MobClick event:@"news_detail_dashang"];
        }else {
            
            [MobClick event:@"tactic_detail_dashang"];
        }
    }
    [getUserCenter ExceptionalAuthorsWithID:[self.model.infoID integerValue] andType:self.bigType == 6 ? 3 : 1];
}
//赞
- (IBAction)zanBtnClick:(UIButton *)sender {
    if (self.bigType == 6) {
        [MobClick event:@"tanbao_detail_dianzan"];
    }else {
        if (self.model.type == 2) {
            [MobClick event:@"news_detail_dianzan"];
        }else {
            
            [MobClick event:@"tactic_detail_dianzan"];
        }
    }
    if (self.detailLikeBlock) {
        self.detailLikeBlock();
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
