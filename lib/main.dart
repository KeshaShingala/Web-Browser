import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: Homepage(),
    ),
  );
}

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  InAppWebViewController? WebController;
  String Url =
      "https://www.google.com/search?q=coding+house+lerning+channel&rlz=1C1YTUH_enIN993IN993&sxsrf=ALiCzsZ-sPZcrWdE3af6nPfvWk1k-lv8sQ%3A1672070098831&ei=0sOpY6WqMrnC4-EPtKqiyAw&oq=coding+house+lerning+ch&gs_lcp=Cgxnd3Mtd2l6LXNlcnAQAxgBMgcIIRCgARAKMgcIIRCgARAKMgcIIRCgARAKMgcIIRCgARAKMggIIRAWEB4QHToKCAAQRxDWBBCwAzoNCAAQRxDWBBDJAxCwAzoICAAQkgMQsAM6BQgAEIAEOgYIABAWEB46CAgAEBYQHhAKOgsIABAWEB4Q8QQQCjoNCAAQFhAeEA8Q8QQQCjoFCAAQhgNKBAhBGABKBAhGGABQtwdYnU1g_WdoAXAAeACAAZMCiAHYD5IBBTAuOS4ymAEAoAEByAEGwAEB&sclient=gws-wiz-serp";
  String? currentUrl;
  bool ForWord = false;
  bool Back = false;

  String Data = "";
  PullToRefreshController? refreshController;
  double progress = 0;

  @override
  void initState() {
    super.initState();

    refreshController = PullToRefreshController(onRefresh: (){
      WebController!.reload();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await WebController!.goBack();
        return (currentUrl == Url) ? true : false;
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              "Web-Browser ",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            backgroundColor: Colors.black,
            centerTitle: true,
            leading: (Back)
                ? IconButton(
              onPressed: () async {
                if (WebController != null) {
                  await WebController!.goBack();
                }
                setState(() {});
              },
              icon: Icon(
                Icons.arrow_back_ios_new_outlined,
                color: Colors.white,
              ),
            )
                : Container(),
            actions: [
              IconButton(
                onPressed: () async {
                  if (WebController != null) {
                    await WebController!.reload();
                  }
                  setState(() {});
                },
                icon: Icon(Icons.refresh_outlined),
                color: Colors.white,
              ),
              (ForWord)?  IconButton(
                  onPressed: () async{
                    if(WebController != null)
                    {
                      await WebController!.goForward();
                    }
                  },
                  icon: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.white,
                  ))
                  : Container(),
            ],
          ),
          body: Column(
            children: [
              Container(
                color: Colors.grey.shade900,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    onChanged: (val){
                      setState((){
                        Data = val;
                      });
                    },
                    onSubmitted: (val) async {
                      setState((){
                        Url = val;
                      });
                      await WebController!.loadUrl(
                          urlRequest: URLRequest(
                              url: Uri.parse("https://www.google.com/search?q=$Data&rlz=1C1YTUH_enIN993IN993&oq=&aqs=chrome.0.35i39i362l8.32152883j0j15&sourceid=chrome&ie=UTF-8")
                          )
                      );
                    },
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(

                      suffixIcon: Icon(Icons.search,color: Colors.grey,),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),),
                      hintText: "Search",
                      fillColor: Colors.white,
                      hintStyle: TextStyle(color: Colors.grey),
                      contentPadding: EdgeInsets.all(15),
                    ),
                  ),
                ),
              ),
              LinearProgressIndicator(
                value: progress,
              ),
              Expanded(
                child: InAppWebView(
                  initialUrlRequest: URLRequest(url: Uri.parse(Url)),
                  pullToRefreshController: refreshController,
                  onWebViewCreated: (controller) {
                    setState(() {
                      WebController = controller;
                    });
                  },
                  onLoadStart: (controller ,url) async{
                    setState((){
                      currentUrl = url.toString();
                    });
                    ForWord = await WebController!.canGoForward();
                    Back = await WebController!.canGoBack();
                    setState((){});
                  },
                  onLoadStop: (controller ,url) async{
                    setState((){
                      currentUrl = url.toString();
                    });
                    ForWord = await WebController!.canGoForward();
                    Back = await WebController!.canGoBack();
                    setState((){});
                  },
                ),
              ),
            ],
          )),
    );
  }
}
